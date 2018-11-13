## Initiation à la blockchain au travers d'une crypto-monnaie (Ether) : Découverte d'Ethereum
-------------

### Premiers pas : Création d'un compte et premières transactions

**1.** Créer un compte en lançant le script `create_account.sh`

//Explication de ce que compte

**2.** On va maintenant allouer une certaine somme d'Ether, *1000000000000000000000* à cet utilisateur, pour cela ouvrez le fichier CustomGenesis.json, et remplacez le champ *ADDRESS* par l'adresse que vous venez de générer :

```console
  "alloc": {
    "ADDRESS": {
      "balance": "1000000000000000000000"
    }
  }
```

https://medium.com/taipei-ethereum-meetup/beginners-guide-to-ethereum-3-explain-the-genesis-file-and-use-it-to-customize-your-blockchain-552eb6265145 : infos sur contenu genesis

// explication contenu + ce que bloc de génèse

**3** Lancement : `init.sh` + `run.sh` +vérifier user bien créé : `eth.accounts` + vérifier solde : eth.getBalance(eth.accounts[0])

**4** Créer second compte `personal.newAccount()` avec mdp  de votre choix + vérifier fonctionnement avec `eth.accounts` mais également le solde de ce second user, que vaut il ?

**5** Transaction d'un user à un autre : `eth.sendTransaction({from:eth.accounts[0], to:eth.accounts[1], value:50000})`, nécessaire indiquer password (contenu dans fichier ethereum_pwd.txt)  du sender, sinon pas possible de réaliser transaction : `personal.unlockAccount(eth.accounts[0], "pa55w0rd123")`

Note pour vérifier infos de la transaction en utilisant le *fullhash* généré : ` eth.getTransaction(<fullhash>)`, on peut également voir que cette transaction apparait maintenant dans le bloc en attente de minage : `eth.getBlock("pending")`

**6** Miner block

Cas réel, minage long : explication mais ici comme visible dans genesis, difficulté mis à zéro => minage instantanné


loadScript("mineWhenNeeded.js")

Par défaut, gain minage envoyés à eth0, pas ce qu'on veut ici donc définit add du miner=>

troisième user: personal.newAccount("") (mdp ="") :  

miner.setEtherbase("<ad du troisième user>");

Vérifier balance à 0, vérfier que bien ad miner : eth.coinbase

par défaut, geth mine blocks même si pas de transactions, pour miner un sul bloc loadScript("mineWhenNeeded.js")

Vérifir que nouveau bloc : eth.getBlock(1) + voir infos du bloc, montrer que pointe bien surr celui d'avant


Regarder block minés + vérifier comptes des users et du miner !

Expliquer gas price !!

**7** Bonus : S'il vous reste du temps en fin de TP vous pourrez essayer de créer un cluster local en instanciant un second noeud (autre port et autre dossier) puis en l'ajoutant (commande admin.addPeer), ceci vous permettra de vérifier le fonctionnement : (présenter fonctionnement)

### Deuxième temps : Smart contracts


On va maintenant essayer de mettre en place un smart afin d'en comprendre le fonctionnement.

Avec Ethereum ceci est possible grâce à Solidity, un langage haut niveau conçu pour l'implémentation de contrats

Ouvrir fichier tirelire
Contrat à compiler `tirelire.sol`, tirelire géante dans laquelle tous les users peuvent mettre de l'argent, smart contract = fonctions + paramtres comme on va le voir dans cette partie

première étape :  compilation et génération de diférents fichiers : bin (contract compilé, ce qui va être placé dans la blockcahin), abi : Application Binary Interface, façon d'interagir avec le contenu hexxadécimal de dans un format lisible par un être humain `tirelire.bin`

Grâce aux lignes suivantes, après avoir lancé `solc --abi --bin tirelire.sol` dans un autre terminal dans la console geth on va pouvoir instancier le contrat :

```console

// Stockage du fichier bin, penser à ajouter 0x pour que celui ci soit bien interprété comme du contenu hexadécimal et à mettre des guillements autour !

>tirelireBin = '0x' + "[<BIN provenant du terminal 2 !>]"

// Simple stockage de l'ABI dans une variable (format JSON)

>tirelireAbi = [<abi provenant du terminal 2 !>]

// Signifier à Geth que cette variable est un ABI : tranformer en ABI le JSON

>tirelireInterface = eth.contract(tirelireAbi)

//On débloque l'utilisateur

>personal.unlockAccount(eth.accounts[0], "pa55w0rd123")

// On publie le smart contract

>var tirelireTx = tirelireInterface.new({from: eth.accounts[0],data: tirelireBin,gas: 1000000})

// On récupère le hash

>tirelireTxHash = tirelireTx.transactionHash

// On vérifie qu'une transaction est bien en attente d'être minée (pending)

> txpool.status

// On mine

loadScript("mineWhenNeeded.js")

// On vérifie que l'opération a fonctionné : le reçu d'un contrat est nul jusqu'à ce que celui soit miné

>eth.getTransactionReceipt(greeterTxHash)

// Pour finir, on récupère l'adresse du contrat

>publishedTirelireAddr = eth.getTransactionReceipt(tirelireTxHash).contractAddress

```

```console
tirelireTx.donner({from:eth.accounts[0], value:"50000000000000000"});
eth.getBalance(tirelireTx.address)
tirelireTx.retirer({from:eth.accounts[0]});
```

A smart contract deployed to the Blockchain has an address (its location) and an "abi definition" (the list of things -variables and functions- that you can interact with.)

With those two pieces of information, anyone can interact with any contract.

A smart contract can hold funds just like wallet.

The smart contract can receive value and send that value to another wallet or contract.

Deploying a contract costs funds and each transfer of value incurs additional transaction fees.


SUITE : Modification du contrat

Copiez le fichier `tirelire.sol` dans un nouveau fichier `tirelire_2.sol` sur lequel vous travaillerez jusqu'à la fin de ce tp.

créer une nouvelle variable `uint public nbAcces`, l'instancier à `0` dans le constructeur et l'incrémenter dans la fonction `donner` et la fonction `retirer` pour enregistrer à chaque fois que quelqu'un accède à la tirelire pour y ajouter ou en retirer de l'argent.

Répétez les étapes de la question précédente avec le fichier `tirelire_2.sol` pour que votre nouveau smart contract soit ajouté à la blockchain et utilisable

Conclusions :

On peut donc conclure qu'un smart contract permet l'instanciation de variables dont la valeur sera stockée dans la blockchain et ces variables ne pourront être modifier que par l'appels de fonctions/du constructeur du smart contract.


SUITE 2


Nouvelle idée : fixer un seuil que l'ont veut atteindre pour cela modifier le contrat

Pour cela on va tout d'abord définir une nouvelle valeur,  ajouter une nouvelle ligne : `uint public objectif;` et l'instancier à 100000000000000000 dans le constructeur mais également ajouter une nouvelle ligne dans la fonction retirer : `assert(this.balance >= objectif)` si l'argent disponible dans l'épargne n'est pas suffisant...PAs de retrait possible

Ceci montre que si les termes d'un accord (quel qu'il soit) ne sont pas remplis, il ne pourra pas se dérouler. De plus la valur objectif est impossible à modifier une fois instanciée et est fixée poour toujours, pour le modifier il faudrait modifier le code et donc instancier un nouveau contrat avec une nouvelle adresse sans rapport avec celui ci...les ether stockés ici seront donc perdus !


Suite 2 :

Smart contract ouvert, ainsi avec l'adresse n'importe quel noeud du réseau peut y accéder, de plus avec fonctions en pubic, tout le monde peut y accéder, comme le montre

tirelireInterface.attire(tirelireTx.address).hello() ainsi un être malveillant pourrait aisément dérober le contenu de notre tirelire....

Pour cette raison on va mettre en place un peu de sécurité, seul l'émétteur du smart contract sera en mesure de le modifier, pour cela on instancie un nouvel élément 'address owner' à `msg.sender` dans le constructeur, et on ajoute dans la fonction retirer l'assert permettant de vérifier que l'adresse correspond bien à l'adresse du créateur du smart contract

Sécurité très imp pour prévenir les accès
!!!
