#give the following structure to the json out
[{
    "_type": "url",
    "ie_key": "Youtube",
    "id": "CTPQ7iukNlE",
    "url": "CTPQ7iukNlE",
    "title": "Oh No, Wolfoo Doesn't Know Where His Backpack Is - Wolfoo Kids Stories | Wolfoo Family Kids Cartoon",
    "description": null,
    "duration": 709,
    "view_count": null,
    "uploader": "Wolfoo Family - Official Channel"
  },
  {
    "_type": "url",
    "ie_key": "Youtube",
    "id": "n7dhRTVwhKc",
    "url": "n7dhRTVwhKc",
    "title": "Bufo, Don't Feel Sad! Wolfoo Is Always by Your Side - Wolfoo Kids Stories | Wolfoo Family",
    "description": null,
    "duration": 629,
    "view_count": null,
    "uploader": "Wolfoo Family - Official Channel"
  }
  ]

#filter data based on the duration from the source file.

$cat vds_1666858142_PLRmv7cTm0UJSDFJtsem00rzDxEOarQFcS.json|jq '.[]|select(.duration<600)'
$cat vds_1666858142_PLRmv7cTm0UJSDFJtsem00rzDxEOarQFcS.json|jq '.[]|select(.duration<600)'>> vds_1666858142_PLRmv7cTm0UJSDFJtsem00rzDxEOarQFcS_lessthan10min.json 
$cat vds_1666858142_PLRmv7cTm0UJSDFJtsem00rzDxEOarQFcS.json|jq '.|length'
543
$cat vds_1666858142_PLRmv7cTm0UJSDFJtsem00rzDxEOarQFcS_lessthan10min.json |jq '.|length'
97
$cat vds_1666858142_PLRmv7cTm0UJSDFJtsem00rzDxEOarQFcS_lessthan10min.json |jq '.[]|.id+"\t"+.title' >  vds_1666858142_PLRmv7cTm0UJSDFJtsem00rzDxEOarQFcS_lessthan10min.tsv
