const { syncDB } = require('../../tasks/sync-db');

describe('Preuve de Sync-DB', () => {

    test("iI doit passer ce processus deux fois", () => {

        syncDB();
        const times = syncDB();
        expect( times ).toBe( 2);

    });

});