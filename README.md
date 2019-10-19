# build gov.uk content browser with gov.uk api
## gov json
### index

```js
{
  // root には他に metadata がいっぱいある
  "links": {
    "level_one_taxons": [
      // ここに取れるデータの object が羅列される
      {
        "api_path": "/api/content/entering-staying-uk",
        "base_path": "/entering-staying-uk",
        "content_id": "ba3a9702-da22-487f-86c1-8334a730e559",
        "document_type": "taxon",
        "locale": "en",
        "public_updated_at": "2018-07-11T08:58:32Z",
        "schema_name": "taxon",
        "title": "Entering and staying in the UK",
        "withdrawn": false,
        "details": {
          "internal_name": "Entering and staying in the UK",
          "notes_for_editors": "",
          "visible_to_departmental_editors": true
        },
        "phase": "live",
        "links": {
            // これがないと戻る動作できない
          "root_taxon": [{
            "api_path": "/api/content/",
            "base_path": "/",
            "content_id": "f3bbdec2-0e62-4520-a7fd-6ffd5d36e03a",
            "document_type": "homepage",
            "locale": "en",
            "public_updated_at": "2019-06-21T11:52:37Z",
            "schema_name": "homepage",
            "title": "GOV.UK homepage",
            "withdrawn": false,
            "links": {},
            "api_url": "https://www.gov.uk/api/content/",
            "web_url": "https://www.gov.uk/"}]
        },
        "api_url": "https://www.gov.uk/api/content/entering-staying-uk",
        "web_url": "https://www.gov.uk/entering-staying-uk"
      },
    ]
    // これ以下も metadata っぽい
    "organisations": [
    ],
    "primary_publishing_organisation": [
    ],
    "available_translations": [
    ]
  },
  "description": "",
  "details": {}
}
```