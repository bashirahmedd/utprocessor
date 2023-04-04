//import child_process from "node:child_process"
import fs from "fs"
import ytdl from "ytdl-core"
import readline from "readline"

//public 
export default async function ProcessVideos(videos, jsonFile) {

    if (videos.length === 0) {
        return
    }

    const baseUrl = 'https://www.youtube.com/watch?v='
    const counter = Date.now()
    const target = "/home/naji/Downloads/temp/ytdown/"
    const { id, title, uploader, ...rest } = videos[0]; //get the first item

    const info = await ytdl.getInfo(id);
    const choosenFormat = ytdl.chooseFormat(info.formats, { quality: [17, 18, 22], filter: 'videoandaudio' });

    let outFile = `${target}${counter}_${title}_${uploader}_${id}.mp4`
    let inFile = `${baseUrl}${id}`
    console.log(`Target Id: ${id}`)

    let starttime;
    const video = ytdl(inFile, { filter: format => format.container === 'mp4', format: choosenFormat });
    video.pipe(fs.createWriteStream(outFile));
    video.once('response', () => {
        starttime = Date.now();
    });
    video.on('progress', (chunkLength, downloaded, total) => {
        const percent = downloaded / total;
        const downloadedMinutes = (Date.now() - starttime) / 1000 / 60;
        const estimatedDownloadTime = (downloadedMinutes / percent) - downloadedMinutes;
        readline.cursorTo(process.stdout, 0);
        process.stdout.write(`${(percent * 100).toFixed(2)}% downloaded `);
        process.stdout.write(`(${(downloaded / 1024 / 1024).toFixed(2)}MB of ${(total / 1024 / 1024).toFixed(2)}MB)\n`);
        process.stdout.write(`running for: ${downloadedMinutes.toFixed(2)}minutes`);
        process.stdout.write(`, estimated time left: ${estimatedDownloadTime.toFixed(2)}minutes `);
        readline.moveCursor(process.stdout, 0, -1);
    });
    video.on('retry', (number, err) => {
        console.log(number)
        console.log(err)
    })
    video.on('reconnect', (number, err) => {
        console.log(number)
        console.log(err)
    })
    video.on('end', () => {
        process.stdout.write('\n\n');
        console.log(`Video download completed: ${id}`)
        updateJsonChunk(id, videos, jsonFile)
    });

    process.on('unhandledRejection', (reason, p) => {
        console.error(reason, 'Unhandled Rejection at Promise', p);
    })
    process.on('uncaughtException', function (err) {
        console.error((new Date).toUTCString() + ' uncaughtException:', err.message)
        console.error(err.stack)
        process.exit(1)
    })

    process.on('beforeExit', (code) => {
        console.log('Process beforeExit event with code: ', code);
    })

    process.on('exit', (code) => {
        console.log('Process exit event with code: ', code);
    })
}

//private
async function updateJsonChunk(vidId, videos, jsonFile) {
    console.log('Updating json chunk file for ' + vidId)
    videos.splice(0, 1)
    console.log(videos)
    
    shuffleArray(videos)
    console.log(videos)
    try {
        //fs.writeFileSync(jsonFile, JSON.stringify(videos), { encoding: 'utf8', flag: 'w' })
        await fs.writeFile(jsonFile, JSON.stringify(videos), function (err) {
            if (err) {
                console.log(err);
            }
            console.log("Json file updated...");
        });
    } catch (error) {
        console.log("Something went wrong!", error);
    }
}

//private
function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
}