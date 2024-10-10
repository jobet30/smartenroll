import wixData from "wix-data";
import fs from "fs";

const BRANCH_TO_COLLECTION_MAP = {
  "refs/heads/main": "Production_Collection",
  "refs/heads/qa": "QA_Collection",
  "refs/heads/uat": "UAT_Collection",
  "refs/heads/staging": "Staging_Collection",
};

const currentBranch = process.env.GITHUB_REF;
const collectionName = BRANCH_TO_COLLECTION_MAP[currentBranch];

if (!collectionName) {
  console.error(`No collection name found for branch ${currentBranch}`);
  fs.writeFileSync("output.txt", "false");
  process.exit(1);
}

async function checkCollectionStatus() {
  try {
    const results = await wixData.query("Collection").find();
    const isReady = results.items.some(
      (collection) => collection.name === collectionName
    );
    fs.writeFileSync("output.txt", isReady.toString());
    console.log(`Collection "${collectionName}" status: ${isReady}`);
  } catch (error) {
    console.error("Error querying Collection collection: ", error);
    fs.writeFileSync("output.txt", "false");
    process.exit(1);
  }
}

function logCollectionStatus(results) {
  console.log(`Collection Details for "${collectionName}":`);
  results.items.forEach((item) => {
    console.log(JSON.stringify(item, null, 2));
  });
}

async () => {
  await checkCollectionStatus();
};
