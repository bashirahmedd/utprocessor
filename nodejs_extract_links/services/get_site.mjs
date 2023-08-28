import * as cheerio from 'cheerio';
import got from 'got';

const get_site = async (url) => {

    try {
        const response = await got.get(url);
        const html = await response.body;
        const $ = cheerio.load(html);
        const sites = [];

        $('ul.geo-site-list a').each((index, element) => {
            const attr = $(element).attr('href');
            sites.push(attr);
        });

        return sites;
    } catch (error) {
        console.log(error);
        console.error();
    }
    return [];
}

export const get_subdomain = (site, sub_domains) => {
    let sub_dom = '';
    for(let ind=0; ind < sub_domains.length; ++ind){
        let element = sub_domains[ind];
        if (site.includes(element)) {
            sub_dom = element;
            break;
        }
    } 
    return sub_dom;
}

export default get_site