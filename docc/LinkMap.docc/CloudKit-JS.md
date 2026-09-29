# CloudKit JS

`cloudkit-auth.js` owns one shared authentication lifecycle for website pages and exposes a verified session state to the map. `app/cloudkit.js` reuses that container and chooses the private or shared database explicitly.

Project loading inspects private `projectZone-*` zones and accepted shared zones. A shared Project retains its complete zone identity, including owner. Location loading queries the selected Project's zone using the Location `project` reference. Query pagination is consumed until all batches are collected.

The web map reads Project and Location records; creation, planning, and sharing controls remain in the iOS app. See `cloudkit-auth.js`, `app/cloudkit.js`, `app/project.js`, and `app/location.js`.
