import launch_browser from './services/launch_browser.mjs';
import get_site, { get_subdomain } from './services/get_site.mjs';
import wait_browser from './services/wait_browser.mjs';
import get_craig_config from './config/get_craig_confi.mjs';

const craig_config = get_craig_config();

try {
    const sites = await get_site(craig_config["url"]);
    //console.log(sites);
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
} catch (error) {

    console.log(error);
    console.error();

}