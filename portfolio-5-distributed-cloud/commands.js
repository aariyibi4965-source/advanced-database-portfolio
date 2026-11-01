// Portfolio 5: commands run on the MongoDB Atlas free cluster (KasuwaCluster)
// The data was loaded with the same insert commands as Portfolio 4 (insert_data.js).
// The connection string and password are NOT stored in this repository on purpose.

use("kasuwa_nosql")

// Show the replica set: set name, the 3 nodes and which one is primary
db.hello()

// Write that waits for the majority of the 3 nodes to confirm it
db.products.updateOne({ sku: "PH-CHG-20W" }, { $inc: { stock: -2 } }, { writeConcern: { w: "majority" } })

// Read from a secondary node (a copy of the data)
db.orders.find({}, { _id: 0, orderNumber: 1, status: 1 }).readPref("secondary")