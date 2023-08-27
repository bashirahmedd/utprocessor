import open from 'open';

const launch_browser = async (index, url) => {

    try {
        // open the browser for the first link
        console.log("Opening : " + url);
        await open(url, {
            app: {
                name: '/usr/bin/firefox',
            },
        });
    } catch (error) {
        console.log(error);
    }

}

export default launch_browser;