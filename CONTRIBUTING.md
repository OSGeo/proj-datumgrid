# How to contribute to proj-datumgrid

Consult [PROJ CONTRIBUTING.md](https://github.com/OSGeo/proj.4/blob/master/CONTRIBUTING.md)
for general principles.

This document focuses on how to specifically contribute a new grid to proj-datumgrid.

Preliminary:
* The grid must be in one of the formats understood by PROJ, typically NTv2 (.gsb) for horizontal shift
grids and GTX for vertical shift grids
* The grid must be freely licensed as mentionned in [README.DATUMGRID](README.DATUMGR   ID).
* We consider that you are familiar with the basic [GitHub workflow to submit a pull request](https://help.github.com/en/articles/creating-a-pull-request)

Determine the geographic scope of the grid. We have one sub directory for
continental packages
- europe
- north-america
- oceania
- world

In the case of overseas territory, we have currently made the choice to attach grids
to the continent of the mainland (hence all grids for French territories are in `europe/`,
for USA in `north-america/` etc.)

Let's consider the case of adding a grid for a new European country.
The steps are:
1. Add it in the `europe/` directory
2. Edit the `europe/README.EUROPE` file to describe the grid. You should mention its
   source/provenance, its license, its format (NTv2, GTX, etc.), the source and
   target coordinate reference systems of the grid, its accuracy when known,
   and all other relevant information. Replicating an existing entry will be the
   easiest.
3. Add the grid name in `travis/expected_europe.lst`, sorted alphabetically.
4. Issue the pull request

Adding a grid in a package of grids is not enough to make it directly and transparently
usable by PROJ. If the source and target coordinate reference systems are known of
the PROJ database (typically they have a EPSG code), a transformation for them using
the grid must be referenced in the PROJ database. Generally, the EPSG database will
already have an entry for the grid, sometimes with a slightly different name.
The relevant file to look into is [grid_transformation.sql](https://github.com/OSGeo/proj.4/blob/master/data/sql/grid_transformation.sql)

You may find an entry like the following one:
```
INSERT INTO "grid_transformation" VALUES('EPSG','15958','RGF93 to NTF (2)',NULL,NULL,'EPSG','9615','NTv2','EPSG','4171','EPSG','4275','EPSG','3694',1.0,'EPSG','8656','Latitude and longitude difference file','rgf93_ntf.gsb',NULL,NULL,NULL,NULL,NULL,NULL,'ESRI-Fra 1m emulation',0);
```
This is a transformation from EPSG:4171 (RGF93) to EPSG:4275 (NTF) using the rgf93_ntf.gsb grid.

If the EPSG dataset does not include an entry, a custom entry may be added in the [grid_transformation_custom.sql](https://github.com/OSGeo/proj.4/blob/master/data/sql/grid_transformation_custom.sql) file.

For this grid to be completely known of PROJ, we must add an entry in the database to describe the grid.

This is done in the [grid_alternatives.sql](https://github.com/OSGeo/proj.4/blob/master/data/sql/grid_alternatives.sql) file.

```
INSERT INTO grid_alternatives(original_grid_name,
                              proj_grid_name,
                              proj_grid_format,
                              proj_method,
                              inverse_direction,
                              package_name,
                              url, direct_download, open_license, directory)
                      VALUES ('rgf93_ntf.gsb',
                              'ntf_r93.gsb',    -- the PROJ grid is the reverse way of the EPSG one
                              'NTv2',
                              'hgridshift',
                              1,
                              'proj-datumgrid',
                              NULL, NULL, NULL, NULL);
```
The first value (`original_grid_name`) describes the grid name as in the grid_transformation.sql file.
The second value (`proj_grid_name`) describe the grid name as effectively found in the PROJ grid package. This may be the same value as original_grid_name, or another one
The third value (`proj_grid_format`) describe the grid format: NTv2 or GTX
The fourth value (`proj_method`) describes the type of grid: `hgridshift` for horizontal shift grids or `vgridshift` for vertical shift grids
The fifth value (`inverse_direction`) may be 0 or 1. 1 means that the actual grid in the PROJ grid package operates in the reverse direction as the record in grid_transformation. This is always the case for .gtx files
The sixth value (`package_name`) should be the PROJ package grid where the grid is located: `proj-datumgrid-europe`, `proj-datumgrid-north-america`, `proj-datumgrid-oceania`
Other values should be set to NULL.

After rebuilding the PROJ database (`make`), you can check the output of `src/projinfo -s EPSG:XXXX -t EPSG:YYYY --spatial-test intersects` if the grid is properly recognized.
