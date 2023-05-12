const cron = require('node-cron');
const { syncDB } = require('./tasks/sync-db');


console.log("Commencement de l'application");

cron.schedule('1-59/5 * * * * *', syncDB);
