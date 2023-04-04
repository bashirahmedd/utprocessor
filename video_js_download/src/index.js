//library
import { dirname } from 'path';
import { fileURLToPath } from 'url';

//static resources
//import data from './data/chunk1.json' assert { type: 'json' }

//local services
import LoadVideoData from "./service/loadVideoData.mjs"
import ProcessVideos from './service/processVideos.mjs'


//app config
const basePath = dirname(fileURLToPath(import.meta.url));

//process args
const service = process.argv[2]


switch (service) {
    case "downloadVideos":
        //service specific args        
        const batchId = process.argv[3]
        LoadVideoData(ProcessVideos, batchId, basePath)
        break;
    //case "someotherservice":
    default:
        console.log("Given service is not found!")
        break;
}


