# How to contribute to proj-datumgrid

WARNING: This repository is no longer open for adding new datasets. Starting
with PROJ 7, the [PROJ-data](https://github.com/OSGeo/PROJ-data) repository
is the new home for PROJ datasets.
Go to its [CONTRIBUTING](https://github.com/OSGeo/PROJ-data/blob/master/CONTRIBUTING.md)
instructions

# Old instructions

Consult [PROJ CONTRIBUTING.md](https://github.com/OSGeo/proj.4/blob/master/CONTRIBUTING.md)
for general principles.

This document focuses on how to specifically contribute a new grid to proj-datumgrid.

Preliminary:
* The grid must be in one of the formats understood by PROJ, typically NTv2 (.gsb) for horizontal shift
grids and GTX for vertical shift grids
* The grid must be freely licensed as mentionned in [README.DATUMGRID](README.DATUMGRID).
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
   and all other relevant information.
   For a vertical shift grid, mention the horizontal CRS (interpolation CRS)
   to use.
   Replicating an existing entry will be the easiest.
3. Add the grid name in `travis/expected_europe.lst`, sorted alphabetically.
4. Register the grid in `filelist.csv`
5. Issue the pull request

Adding a grid in a package of grids is not enough to make it directly and transparently
usable by PROJ. If the source and target coordinate reference systems are known of
the PROJ database (typically they have a EPSG code), a transformation for them using
the grid must be referenced in the PROJ database. Generally, the EPSG database will
already have an entry for the grid, sometimes with a slightly different name.
The relevant file to look into is [grid_transformation.sql](https://github.com/OSGeo/proj.4/blob/master/data/sql/grid_transformation.sql). 
If the gris is not yet registered in the EPSG database, you are *strongly* encouraged to
engage with EPSG to register it. This will make its addition to PROJ and its later maintainance
much easier. http://www.epsg.org/EPSGDataset/Makechangerequest.aspx explains the procedure
to follow to submit a change request to EPSG.

You may find an entry like the following one:
```
INSERT INTO "grid_transformation" VALUES(
    'EPSG','15958',             -- transformation code
    'RGF93 to NTF (2)',         -- transformation name
    NULL,NULL,
    'EPSG','9615','NTv2',       -- transformation method
    'EPSG','4171',              -- source CRS
    'EPSG','4275',              -- target CRS
    'EPSG','3694',              -- area of use
    1.0,                        -- accuracy
    'EPSG','8656','Latitude and longitude difference file','rgf93_ntf.gsb', -- grid name
    NULL,NULL,NULL,NULL,
    NULL,NULL,                  -- interpolation CRS
    'ESRI-Fra 1m emulation',
    0);
```
This is a transformation from EPSG:4171 (RGF93) to EPSG:4275 (NTF) using the rgf93_ntf.gsb grid.

Or for a vertical transformation
```
INSERT INTO "grid_transformation" VALUES(
    'EPSG','7001','ETRS89 to NAP height (1)',
    NULL,NULL,
    'EPSG','9665','Geographic3D to GravityRelatedHeight (US .gtx)',
    'EPSG','4937',
    'EPSG','5709',
    'EPSG','1275',
    0.01,
    'EPSG','8666','Geoid (height correction) model file','naptrans2008.gtx',
    NULL,NULL,NULL,NULL,
    'EPSG','4289',              -- interpolation CRS has been manually added
    'RDNAP-Nld 2008',0);
```

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
The fifth value (`inverse_direction`) may be 0 or 1. 1 means that the actual grid in the PROJ grid package operates in the reverse direction as the record in grid_transformation.
The sixth value (`package_name`) should be the PROJ package grid where the grid is located: `proj-datumgrid-europe`, `proj-datumgrid-north-america`, `proj-datumgrid-oceania`
Other values should be set to NULL.

After rebuilding the PROJ database (`make`), you can check the output of `src/projinfo -s EPSG:XXXX -t EPSG:YYYY --spatial-test intersects` if the grid is properly recognized.

# Examples

## Pull request for a horizontal shift grid *not* registered in EPSG:

- in proj-datumgrid: https://github.com/OSGeo/proj-datumgrid/pull/89
- in PROJ itself: https://github.com/OSGeo/PROJ/pull/1791

## Pull request for a horizontal shift grid registered in EPSG:

- in proj-datumgrid: https://github.com/OSGeo/proj-datumgrid/pull/88
- in PROJ itself: https://github.com/OSGeo/PROJ/pull/1789

