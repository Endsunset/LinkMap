# How LinkMap Works

A Project holds the long-lived map and resources. An Activity holds one cycle of work within that Project.

## The Main Loop

LinkMap opens on the Map. Open Dashboard → Context to choose a Project, Activity, and optional Assignment. Choosing a new Project clears the previous Activity and Assignment; choosing a new Activity clears the Assignment. Dashboard also opens the current Project and Activity details.

Build the Project foundation first: Regions, Layers, Locations, Items, and Inventory. Then create an Activity with Assignments and Routes. Follow the Routes on the Map, record resource movements through Transactions, and review the resulting balances and reports.

## Why the Separation Matters

A Location or Item can be reused across many Activities. Routes, Stops, Assignments, and Activity resource movements belong to a specific Activity. Archiving an Activity preserves its history while the Project remains available for the next round.

- <doc:Project>
- <doc:Activities>
- <doc:Architecture>
