import find from 'find-process';

// 'name',       /.*?\/kidoAgent\/Broker\/process.js.*/ // regex pattern

const watch_browser = async () => {

    const processesList = await find(
        'name', 'firefox', true
    );
    //console.log({ processesList });
    if (processesList.length === 0) {
        return true;
    }
    return false;

}

export default watch_browser