import * as cheerio from 'cheerio';
import got from 'got';
import launch_browser from './services/launch_browser.mjs';


const url = 'https://geo.craigslist.org/iso/ca';

try {
    const response = await got.get(url);
    const html = response.body;
    const $ = cheerio.load(html);

    $('ul.geo-site-list a').each((index, element) => {
        const attr = $(element).attr('href');
        launch_browser(index, attr);
    });
} catch (error) {
    console.log(error);
    console.error();
}



/* links.push({
    text: $(element).text(), // get the text
    href: $(element).attr('href'), // get the href attribute
});
 */