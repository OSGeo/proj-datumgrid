#!/bin/bash

# Requires GDAL 2.4 for support of the .mnt format

set -eu

rm -rf  build_french_vgrids
mkdir build_french_vgrids
cd build_french_vgrids

# See https://geodesie.ign.fr/index.php?page=grilles

array=(
     # France metropole
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/metropole/RAF18.mnt'

     # Corse
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/metropole/RAC09.mnt'

    # Guadeloupe RGAF09
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/RAGTBT2016.mnt'

    # La Desirade RGAF09
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/RALD2016.mnt'

    # La Desirade WGS84
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/RALDW842016.mnt'

    # Les Saintes RGAF09
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/RALS2016.mnt'

    # Martinique RGAF09
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/RAMART2016.mnt'

    # Marie Galante RGAF09
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/RAMG2016.mnt'

    # Saint Barthelemy RGAF09
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/gg10_sbv2.mnt'

    # Saint Martin RGAF09
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/gg10_smv2.mnt'

    # Les Saintes WGS84
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggg00_lsv2.mnt'

    # Marie Galante WGS84
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggg00_mgv2.mnt'

    # Saint Barthelemy WGS84
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggg00_sbv2.mnt'

    # Saint Martin WGS84
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggg00_smv2.mnt'

    # Guadeloupe WGS84
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggg00v2.mnt'

    # Guyane RGF95
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggguy15.mnt'

    # Iles Kerguelen
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggker08v2.mnt'

    # Martinique WGS84
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggm00v2.mnt'

    # Mayotte GGM04
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggm04v1.mnt'

    # Bora bora (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf02-Bora.mnt'

    # Huahine (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf02-Huahine.mnt'

    # Maiao (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf02-Maiao.mnt'

    # Maupiti (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf02-Maupiti.mnt'

    # Raietea (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf02-Raiatea.mnt'

    # Tahaa (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf02-Tahaa.mnt'

    # Tupai (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf02-Tupai.mnt'

    # Hiva Oa (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf05-HivaOa.mnt'

    # Nuku Hiva  (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf05-Nuku.mnt'

    # Fakarava  (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf08-Fakarava.mnt'

    # Gambier  (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf08-Gambier.mnt'

    # Hao  (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf08-Hao.mnt'

    # Mataiva  (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf08-Mataiva.mnt'

    # Raivavae  (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf08-Raivavae.mnt'

    # Reao (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf08-Reao.mnt'

    # Rurutu (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf08-Rurutu.mnt'

    # Tikehau (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf08-Tikehau.mnt'

    # Tubuai (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf08-Tubuai.mnt'

    # Moorea (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf10-Moorea.mnt'

    # Tahiti (French Polynesia)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggpf10-Tahiti.mnt'

    # Saint-Pierre et Miquelon (GGSPM06)
        'https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/ggspm06v1.mnt'
)

for i in "${array[@]}"; do
    wget $i
    gdal_translate -ot Float32 -of GTX `basename $i` `basename $i .mnt`.gtx
done

# Reunion grille RAR
i='https://geodesie.ign.fr/contenu/fichiers/documentation/grilles/outremer/RAR07_bl.gra'
wget $i
gdal_translate `basename $i` tmp.tif -a_nodata 9999 -ot Float32 && gdalwarp tmp.tif `basename $i .gra`.gtx -dstnodata -88.8888015747070312 -of GTX && rm tmp.tif
