$sudo apt update
$sudo apt install -y jq
$jq --version

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

$jq '.[]|select(.duration<600)|.id' test.json >> batch1.txt

remove qoutes from  id string 
$jq -r '.[]|select(.duration<600)|.id' test.json >> batch1.txt   

to get all ids of the videos
$jq -r '.[]|.id' PLI6jYYEI0TDqmDJv8zG9Zg7TkXk-atjht.json
$jq -r '.[]|.id' PLI6jYYEI0TDqmDJv8zG9Zg7TkXk-atjht.json >> PLI6jYYEI0TDqmDJv8zG9Zg7TkXk-atjht.txt

$cat all_merged_urls.txt |jq '.[]|select(.duration<1800)'> all_merged_urls_lessthan30min.tx
$cat vds_sem00rzDxEOarQFcS.json|jq '.[]|select(.duration<600)'
$cat vds_sem00rzDxEOarQFcS.json|jq '.[]|select(.duration<600)'>> vds_sem00rzDxEOarQFcS_lessthan10min.json 
$cat vds_sem00rzDxEOarQFcS.json|jq '.|length'
543
$cat vds_sem00rzDxEOarQFcS_lessthan10min.json |jq '.|length'
$cat all_merged_urls.txt |jq '.|length'
97
$cat vds_sem00rzDxEOarQFcS_lessthan10min.json |jq '.[]|.id+"\t"+.title' >  vds_sem00rzDxEOarQFcS_lessthan10min.tsv


detailed information on each episode of the playlist
$ youtube-dl --no-call-home --dump-json https://www.youtube.com/playlist?list=PLI6jYYEI0TDosbAsew3Iauk6n_lCqXjAb | jq >> test.json
