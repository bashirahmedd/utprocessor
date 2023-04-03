import fs from "fs";

export default async function LoadVideoData(externalFunction, batchId, basePath) {
    
    try {
        let videosInfo = [];
        let jsonFile=`${basePath}/data/chunk${batchId}.json`
        
        if (fs.existsSync(jsonFile)) {          
          await fs.readFile(jsonFile, function (err, data) {
            videosInfo = JSON.parse(data.toString());
        
            if (err) {
              console.log(err);
              return;
            }
    
            if (externalFunction && !err) {
              externalFunction(videosInfo, jsonFile);
              return;
            }
          });

        } else {
          if (externalFunction) {
            externalFunction(videosInfo, jsonFile);
            return;
          }
        }
      } catch (error) {
        console.error(`Something Happened: ${error.message}`);
      }
                
}