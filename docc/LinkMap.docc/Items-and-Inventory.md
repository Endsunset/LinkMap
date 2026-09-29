# Items and Inventory

An Item names a resource that may be carried, delivered, used, or counted. Inventory is a Project resource anchor for those Items.

Add Items once in the Project. Use Inventory for stock locations, then move quantities with Transactions. An Item’s quantity is derived from incoming minus outgoing Transactions for the selected anchor; it is not stored directly on the Item or Inventory.

Inventory supports adding from or removing to Outside, transferring between Inventories, and supplying an Activity. The allowed flow depends on both endpoints.

- <doc:Transactions-and-Reports>
