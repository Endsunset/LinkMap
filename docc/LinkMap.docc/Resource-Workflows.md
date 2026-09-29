# Resource Workflows

The native Project contains reusable Items and Inventory. An Activity, Assignment, or Stop can also hold Item quantities. A balance is derived from Transactions moving an Item into or out of one of those anchors; quantities are not stored directly on the anchor.

A Transaction has one Item, a positive quantity, optional source and destination, and a note. Project-level flows connect Outside and Inventory, two Inventories, or Inventory and Activity. Activity-level flows connect Activity, Assignment, and Stop anchors within the same Activity. The direction matters: the active transaction identity is Item plus source plus destination.

`ResourceCentreView` presents Project-wide and contextual resource pivots and owns balance, history, and correction workflows. Activity preparation can draft movements from Inventory to Activity and then to Assignment; the workflow validates projected balances before saving. See `ARCHITECTURE.md`, `WORKFLOW.md`, `LinkMap/Utilities/CKUtility/CKUtility+Transaction.swift`, and the Resource Centre views in LinkMap-core.
