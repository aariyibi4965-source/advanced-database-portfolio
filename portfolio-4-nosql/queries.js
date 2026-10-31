use("kasuwa_nosql")

// Query 1: all fashion products
db.products.find({ category: "Fashion" })

// Query 2: products over 10,000, most expensive first
db.products.find({ price: { $gt: 10000 } }, { _id: 0, name: 1, price: 1 }).sort({ price: -1 })

// Query 3: search inside the flexible attributes
db.products.find({ "attributes.auto_shutoff": true }, { _id: 0, name: 1, attributes: 1 })

// Query 4: one customer's order, read as a single document
db.orders.find({ "customer.email": "amina.bello@example.com" }, { _id: 0, orderNumber: 1, status: 1, total: 1, items: 1 })

// Query 5: updates (a sale reduces stock, a customer adds a review)
db.products.updateOne({ sku: "PH-CHG-20W" }, { $inc: { stock: -2 } })
db.products.updateOne({ sku: "HK-KET-18" }, { $push: { reviews: { customer: "Tunde Adebayo", rating: 4, comment: "Boils quickly" } } })
db.products.find({ sku: { $in: ["PH-CHG-20W", "HK-KET-18"] } }, { _id: 0, name: 1, stock: 1, reviews: 1 })

// Query 6: revenue per payment method
db.orders.aggregate([{ $match: { "payment.status": "Successful" } }, { $group: { _id: "$payment.method", orders: { $sum: 1 }, revenue: { $sum: "$payment.amount" } } }, { $sort: { revenue: -1 } }])

// Query 7: best-selling products
db.orders.aggregate([{ $unwind: "$items" }, { $group: { _id: "$items.name", unitsSold: { $sum: "$items.quantity" } } }, { $sort: { unitsSold: -1 } }, { $limit: 5 }])

// Query 8: execution plan before the index (COLLSCAN expected)
db.products.find({ sku: "HK-KET-18" }).explain("executionStats").queryPlanner.winningPlan

// Create a unique index on sku
db.products.createIndex({ sku: 1 }, { unique: true })

// Execution plan after the index (IXSCAN expected)
db.products.find({ sku: "HK-KET-18" }).explain("executionStats").queryPlanner.winningPlan