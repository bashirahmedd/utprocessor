import launch_browser from './services/launch_browser.mjs';
import get_site, { get_subdomain } from './services/get_site.mjs';
import wait_browser from './services/wait_browser.mjs';
import get_craig_config from './config/get_craig_confi.mjs';
import watch_browser from './services/watch_browser.mjs';

const craig_config = get_craig_config();

try {
    const sites = await get_site(craig_config["url"]);
    let isFFLoaded = await watch_browser();
    
    if (!isFFLoaded) {  //Firefox is loaded
        for (let index = 0; index < sites.length; ++index) {
            let sub_dom = get_subdomain(sites[index], craig_config.sub_domains)
            if (sub_dom != '') {
                let search = [craig_config["all_search"], ...craig_config[sub_dom]['extended_search']];
                for (let sind = 0; sind < search.length; ++sind) {
                    await launch_browser(index, sites[index] + search[sind]);
                    const result = await wait_browser();
                }
            }
        }
    } else {
        console.info('Firefox is not loaded. Please launch Firefox...')
    }
} catch (error) {

    console.log(error);
    console.error();

}