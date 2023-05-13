
let times =0;

const syncDB = () => {
    times++;
    console.log('tick multiple de 5 - :', times);

    return times;
}

module.exports ={
    syncDB
}