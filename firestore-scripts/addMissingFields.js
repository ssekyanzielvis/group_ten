const admin = require('firebase-admin');

const serviceAccount = require('lib\food-delivery-fc9ed-firebase-adminsdk-87cj8-e4c33130f2.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function addMissingFields() {
  const restaurantsSnapshot = await db.collection('restaurants').get();

  const updatePromises = [];

  restaurantsSnapshot.forEach((doc) => {
    if (!doc.data().hasOwnProperty('price')) {
      updatePromises.push(doc.ref.update({ price: 0.0 })); // Add default price if missing
    }
  });

  await Promise.all(updatePromises);
  console.log('Missing fields added.');
}

addMissingFields().catch(console.error);
