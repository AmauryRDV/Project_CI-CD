const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('API de test déployée avec succès');
});

app.listen(port, () => {
  console.log(`API en écoute sur http://localhost:${port}`);
});
