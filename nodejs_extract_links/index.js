import launch_browser from './services/launch_browser.mjs';
import get_site from './services/get_site.mjs';
import wait_browser from './services/wait_browser.mjs';

const url = 'https://geo.craigslist.org/iso/ca';
const job_postfix='/search/jjj#search=1~thumb~0~0';
try {

    const sites = await get_site(url);
    for (let index = 0; index < sites.length; ++index) {
        await launch_browser(index, sites[index]+job_postfix);
        const result = await wait_browser();
    }

} catch (error) {

    console.log(error);
    console.error();

}