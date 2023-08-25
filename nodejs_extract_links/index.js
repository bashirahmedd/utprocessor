import * as cheerio from 'cheerio';
import got from 'got';
import open, { openApp, apps } from 'open';


const url = 'https://geo.craigslist.org/iso/ca';

try {
    const response = await got.get(url);
    const html = response.body;
    const $ = cheerio.load(html);

    $('ul.geo-site-list a').each((index, element) => {
        const attr = $(element).attr('href');
        (async () => {
            try {
                console.log(index);
                if(index < 1){
                    await open(attr);
                }
            } catch (error) {
                console.log(error);
            }
        })();
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