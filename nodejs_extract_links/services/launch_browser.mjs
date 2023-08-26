import open from 'open';

const launch_browser = async (index, attr) => {

    try {
        if (index < 1) {
            // open the browser for the first link
            await open(attr);
        }
        console.log(index);
    } catch (error) {
        console.log(error);
    }

}

export default launch_browser;