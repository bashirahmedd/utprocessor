import watch_browser from "./watch_browser.mjs";
import {
    setTimeout,
} from 'timers/promises';

const wait_browser = async () => {

    let brcnt = 0;
    const browser_check= 1000 * 5;
    while (true) {

        const res = await setTimeout(browser_check, 'result');
        const result = await watch_browser();
        if(result){
            break;                
        }
        console.log(res +' : '+ brcnt);
        ++brcnt
    }
}

export default wait_browser