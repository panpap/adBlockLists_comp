const puppeteer = require('puppeteer');
const {AdBlockClient, FilterOptions} = require('ad-block')

function loadLists(blockList) {
    var client = new AdBlockClient();
    console.log("reading "+blockList);
    var fs = require('fs');
    var content = fs.readFileSync(blockList, 'utf8');
    var lines=content.split("\n")
    for (var i=0;i<lines.length; i++){
        if (lines[i].charAt(0) == "!") { //do nothing
        } else {
            client.parse(lines[i]) //"'"+line.split("\n")[0]+"'")
        }
    }
    console.log("DONE with reading filter")
    return client
}

function matchTrace(urls,name,client,list){
    var i=0;
    for (var j=0;j<urls.length;j++){
        var b1 = client.matches(urls[j], FilterOptions.script, name)
        if (b1) {
            i = i + 1
        }
    }
    //filtered results for the domain
    console.log("List: "+list+" Domain "+name+" TotalReqs: "+urls.length+" blocked: "+i)//+" "+client.getMatchingStats().numExceptionHashSetSaves)
}

const easyListclient = loadLists("./blocklists/easylist.txt");
const easyPrivacyclient= loadLists("./blocklists/easyprivacy.txt");
const easyChinaclient=loadLists("./blocklists/easylistchina.txt");
puppeteer.launch().then(async browser => {
   // const browser = await puppeteer.launch();
    console.log("puppeteer launched")
    var fs = require('fs');
    var content = fs.readFileSync("alexa.txt",'utf8');//"alexa-top-1k.txt", 'utf8');
    domains=content.split("\n")
    for (var i=0;i<domains.length;i++){
        var urls = [];
        var domain = domains[i]
        //if (domain.length>2) {
            const page = await browser.newPage();
            await page.setRequestInterception(true);
            console.log("Running " + domain)
            sitename = domain.split("//")[1]
            page.on('request', interceptedRequest => {
                //intercept requests and capture urls
                urls.push(interceptedRequest.url())
                interceptedRequest.continue();
            });
            await page.goto(domain);
            // DONE with parsing
            matchTrace(urls, sitename, easyListclient, "EasyList")
            matchTrace(urls, sitename, easyPrivacyclient, "EasyPrivacy")
            matchTrace(urls, sitename, easyChinaclient, "EasyChina")
       // }
    }
    await browser.close();
});