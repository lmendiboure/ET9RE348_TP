## Initiation à la blockchain au travers d'une crypto-monnaie (Ether) : Découverte d'Ethereum
-------------

Pour cette mise en pratique, nous allons utilser Geth (Go Ethereum), l'implémentation Go d'Ethereum (https://geth.ethereum.org/). D'autres implémentations d'Ethereum existent mais présentent certains désavantages : l'implémentation C++ est difficile à prendre en main et l'implémentation Python ne possède actuellement pas de version stable.

L'autre outil important ici est le compiler solidity (https://solidity.readthedocs.io/en/v0.4.21/), solc. Celui ci va nous permettre de compiler les fichiers Solidity utilisés pour l'implémentation de smart contracts avec Ethereum.

Pour ce qui est de l'installation de ces outils (Go, Geth et solc), celle ci pourra aisément être réalisée grâce au script `./install.sh`. S'ils ne sont pas installés sur cette machine, lancez donc ce script et vous devriez vous retrouver avec un environnement fonctionnel.  

Ici, nous allons utiliser un environnement de test, et par conséquent une blockchain privée dans laquelle nous pourrons créer des utilisateurs, attribuer des ethers, réaliser des transactions, développer et tester des smart contracts de façon gratuite et rapide.

### Premiers pas : Création d'un compte et premières transactions
______

**1. Création d'un utilisateur**  
Pour pouvoir intéragir avec Ethereum, l'utilisation d'un compte Ethereum est essentielle. Celui ci possède un solde (un nombre d'ethers, *ether balance*), permet l'envoi de transactions, qu'il s'agisse de transactions monétaires ou de smarts contracts et enfin est contrôlé par une clé privée qui permet de le sécuriser.
 Il va ici être facile d'en créer un en lançant le script `./peer1/create_account.sh`.

 Ceci en faisant appel à la commande *geth* va simplement demander la création d'un nouvel utilisateur ayant pour mot de passe le mot de passe stocké dans le fichier */peer1/ethereum_pwd.txt*. Une fois cet utilisateur créé une adresse va être générée, celle ci correspond à l'identifiant unique de notre utilisateur, stocké dans la blockchain et et qui permettra de l'authentifier lorsqu'il cherchera à intéragir avec la blockchain mais également d'identifier toutes les transactions qu'il aura réalisé (permettant par exemple de connaitre son solde à un moment donné).


**2. Configuration**  
On va maintenant allouer une certaine somme d'Ether à cet utilisateur que nous venons de créer : *1000000000000000000000* (bien sûr ceci n'est possible que dans le cas d'une blockchain privée...).
Pour cela ouvrez le fichier `genesis.json`, et remplacez le champ *ADDRESS* par l'adresse que vous venez de générer :

```console
  "alloc": {
    "ADDRESS": {
      "balance": "1000000000000000000000"
    }
  }
```

Le *genesis block* (https://bitcoin.fr/bloc-genesis/) correspond au tout premier bloc d'une blockchain qui permet d'instancier la blockchain et de créer un premier lien à partir duquel pourra se construire l'ensemble de la chaine. Dans le cas réel, ce bloc hardcodé contient  des données arbitraires, généralement une certaine somme d'argent à laquelle il sera impossible d'accéder par la suite.

Dans notre cas ce genesis block est créé grâce au fichier `genesis.json` qui correspond en quelque sorte à sa configuration. Celui ci comprend différents champs, notamment le champ *config* qui permet de définir certains paramètres de la blockchain tels que son ID. D'autres champs importants pour nous sont :

- *alloc* qui permet d'allouer un certain nombre d'ethers à une adresse donnée;

- la difficulté qui correspond à la complexité nécessaire à  la résolution du "puzzle" permettant de miner le hash d'un bloc donné ; dans notre cas afin que le minage soit très rapide (automatique), cette valeur est définie à 0. Dans un cas réel, afin que celui ci soit maintenu à une vitesse constante, cette difficulté évolue en fonction du nombre de mineurs et de la puissance de calcul de la blockchain;

- le timestamp, moment d'émission du bloc.


**3. Lancement**  
Maintenant que nous avons créé un utilisateur et modifié le fichier de configuration, nous allons accéder à la blockchain.
Pour ceci il va falloir dans un premier temps lancer le script `./peer1/init.sh` qui va permettre d'initier la blockchain avec la configuration que nous venons de définir. Maintenant que ceci est réalisé, nous allons pouvoir accéder à la blockchain. Pour ceci il va falloir lancer le script `./peer1/run.sh`.

Nous voici maintenant dans la blockchain, à ce stade, on peut vérifier deux choses :

- que l'utilisateur que nous avons créé est bien dans la blockchain avec la commande `eth.accounts` qui liste l'ensemble des utilisateurs

- que la somme demandée a bien été créditée sur le compte de l'utilisateur avec la commande `eth.getBalance(eth.accounts[0])`


**4. Création de deux autres utilisateurs**  
Nous allons maintenant créer deux nouveaux utilisateurs. Le premier de ces deux utilisateurs va nous permettre de découvrir le fonctionnement des transactions. Pour ce qui est du second, nous allons par la suite le définir comme *mineur* afin d'observer la rétribution de ceux-ci lors du minage de blocs.

- a. Créz deux nouveaux utilisateurs, en répétant deux fois la commande `personal.newAccount()`, il vous sera demandé de définir un mot de passe pour ces utilisateurs. Afin de nous simplifier la vie, nous pouvons définir ce mot de passe comme étant une chaine de caractères vide *""*, pour cela il vous suffit de presser la touche [Entrée].

- b. maintenant que ces deux comptes sont créés, grâce aux commandes utilisées dans la question **3**, vérifiez que la création de ces deux comptes est effective et regardez le solde de ces deux nouveaux utilisateurs. Que vaut il ?  


**5. Lancement d'un mineur**   
Maintenant que ces deux utilisateurs sont créés, nous allons définir dans notre blockchain un compte mineur qui recevra l'argent perçu par le noeud pour le minage des blocs.

Pour cela il va tout d'abord falloir indiquer au système quelle est l'adresse du noeud mineur, pour ce faire, utilisez la commande `miner.setEtherbase("<ad du troisième user>")`. Vous pouvez vérifier que l'opération a fonctionné en utilisant la commande `eth.coinbase`.

Maintenant que ceci est réalisé, nous allons pouvoir lancer le minage. Normalement, en utilisant une blockchain privée avec ethereum, le minage est réalisé de façon continue, que des transactions soient en attente ou pas. Afin de ne miner que les blocs nécessaires, nous allons lancer le script  `loadScript("./js_scripts/mineWhenNeeded.js")` qui vérifie que des transactions sont bien en attente avant de lancer le minage.

Vous pourrez constater qu'au premier lancement de ce script et donc au premier *minage* la ligne *Generating DAG in progress* s'affiche à de nombreuses reprises (environ une minute). Comme expliqué ici (https://github.com/ethereum/wiki/wiki/Ethash-DAG), ceci est dû au fait que pour que le système (consensus) de PoW (Proof of Work) fonctionne il est nécessaire qu'un nouveau client génère une certaine quantité de *travail*.

**6. Une première transaction**  
Maintenant que l'environnement de travail est prêt (instanciation des comptes, lancement du minage) nous allons pouvoir effectuer une première transaction. Avant tout, nous allons observer le nombre de blocs actuellement présents dans la chaine grâce à la commande `eth.blockNumber`. On peut également observer le contenu de ce bloc, et retrouver les champs provenant du fichier `genesis.json` grâce à la commande `eth.getBlock(<numero_de_bloc>)`.

Une fois ceci réalisé, on peut réaliser une premier transaction grâce à la commande `eth.sendTransaction({from:eth.accounts[0], to:eth.accounts[1], value:5000000000})` qui contient trois infomations : l'émetteur (premier utilisateur créé), le récepteur (second utilisateur créé) ainsi que la valeur de la transaction. Afin que cette commande soit possible, il sera très certainement nécessaire d'indiquer mot de passe de l'émetteur, ce qui permettra de l'authentifier et de rendre possible la transaction : `personal.unlockAccount(eth.accounts[0], "pa55w0rd123")`. Ceci montre que sans la clé privée d'un utilisateur, il sera impossible d'interagir avec la blockchain en utilisant simplement son adresse.

Note pour vérifier infos de la transaction en utilisant le *fullhash* généré : ` eth.getTransaction(<fullhash>)`, on peut également voir que cette transaction apparait maintenant dans le bloc en attente de minage : `eth.getBlock("pending")`

Vérifir que nouveau bloc : eth.getBlock(1) + voir infos du bloc, montrer que pointe bien surr celui d'avant

Expliquer gas price !!


Regarder block minés + vérifier comptes des users et du miner !


**7** Ajout d'un second pair/noeud :

présenter fonctionnement

Dans second terminer aller dans dossier peer_2 et :

Lancer `./peer2/init.sh`, principale différence : nouveau dossier de stockage des données mais même fichiers d'init pour que même bloc de CustomGenesis

Lancer  `./peer2/run.sh`, différence, toujours dossier + port exposé

Dans terminal 2 : taper `admin.nodeInfo` pour récuprer les infos concernant le noeud, recopier la valeur de l'enode (ID du noeud) et dans le terminal 1 lancer la commande `admin.addPeer(<ENODE 2>)`, vérifier le fonctionnement avec la commande admin.peers, le pair devrait maintenant s'afficher, ie maintenant réseau local Blockchain
Maintenant afficher numéro block courant dans T2 (eth.blockNumber) et lancer nouvelle transaction dans noeud 1 pour que minage soit réalisé, après quelques secondes, peut constater affichage  Imported new chain segment, peut afficher à nouveau le numéro de bloc ++ explication !

### Deuxième temps : Smart contracts


On va maintenant essayer de mettre en place un smart afin d'en comprendre le fonctionnement.

Avec Ethereum ceci est possible grâce à Solidity, un langage haut niveau conçu pour l'implémentation de contrats

Ouvrir fichier tirelire dans smart_contract
Contrat à compiler `tirelire.sol`, tirelire géante dans laquelle tous les users peuvent mettre de l'argent, smart contract = fonctions + paramtres comme on va le voir dans cette partie

première étape :  compilation et génération de diférents fichiers : bin (contract compilé, ce qui va être placé dans la blockcahin), abi : Application Binary Interface, façon d'interagir avec le contenu hexxadécimal de dans un format lisible par un être humain `tirelire.bin`

Grâce aux lignes suivantes, après avoir lancé `solc --abi --bin tirelire.sol` dans un autre terminal dans la console geth on va pouvoir instancier le contrat :

Note : si vous utilisez Debian, solc n'est pas installé, une solution pour pouvoir tout de même l'utiliser est de passer par `https://remix.ethereum.org/` après être accédé à cette page dans un navigateur, collez le code du fichier `tirelire.sol` à la place du code présent sur l'interface. Cliquez ensuite sur *Start to compile* une fois que c'est réalisé, cliquez une *Details*, il va maintenant vous être possible de récupérer l'ABI et le code bin. Note, ce qui nous intéresse dans le code bin est uniquement le champ `object`, veuillez à ne pas copier l'ensemble de l'objet!

```console

// Stockage du fichier bin, penser à ajouter 0x pour que celui ci soit bien interprété comme du contenu hexadécimal et à mettre des guillements autour !

tirelireBin = '0x' + "[<BIN provenant du terminal 2 !>]"

// Simple stockage de l'ABI dans une variable (format JSON)

tirelireAbi = [<abi provenant du terminal 2 !>]

// Signifier à Geth que cette variable est un ABI : tranformer en ABI le JSON

tirelireInterface = eth.contract(tirelireAbi)

//On débloque l'utilisateur

personal.unlockAccount(eth.accounts[0], "pa55w0rd123")

// On publie le smart contract

var tirelireTx = tirelireInterface.new({from: eth.accounts[0],data: tirelireBin,gas: 1000000})

// On récupère le hash

tirelireTxHash = tirelireTx.transactionHash

// On vérifie que l'opération a fonctionné : le reçu d'un contrat est nul jusqu'à ce que celui soit miné

eth.getTransactionReceipt(tirelireTxHash)

// Pour finir, on récupère l'adresse du contrat

publishedTirelireAddr = eth.getTransactionReceipt(tirelireTxHash).contractAddress

```

```console
tirelireTx.donner({from:eth.accounts[0], value:"50000000000000000"});
eth.getBalance(tirelireTx.address)
tirelireTx.retirer({from:eth.accounts[0]});
ti	tirelireTx.hello()
```

/// pending : txpool.status

Pour tester sur le second noeud on va avoir besoin de trois choses : à nouveau récupérer l'abi du contrat, le convertir en contrat et pour finir de l'adresse du contrat, dans le terminal 2:

```console
tirelireAbi = [<abi provenant du terminal 2 !>]
tirelireInterface = eth.contract(tirelireAbi)
tirelireTx.at(<adresse du smart contract>).hello()
```

Comme on peut le constater, un contrat est défini par deux choses : sont abi (liste d'intéractions possibles) et son adresse et avec cela il est possible d'y accéder depuis n'importe quel endroit dans le réseau

On peut également constater qu'un smart contract peut également contenir de l'argent et par conséquent que son adresse correspond aussi à une adresse

Enfin comme tout type de transaction, l'instanciation et l'interaction avec le smart contract coute de l'argent.

SUITE : Modification du contrat

Copiez le fichier `tirelire.sol` dans un nouveau fichier `tirelire_2.sol` sur lequel vous travaillerez jusqu'à la fin de ce tp.

créer une nouvelle variable `uint public nbAcces`, l'instancier à `0` dans le constructeur et l'incrémenter dans la fonction `donner` et la fonction `retirer` pour enregistrer à chaque fois que quelqu'un accède à la tirelire pour y ajouter ou en retirer de l'argent.

Répétez les étapes de la question précédente avec le fichier `tirelire_2.sol` pour que votre nouveau smart contract soit ajouté à la blockchain et utilisable

Conclusions :

On peut donc conclure qu'un smart contract permet l'instanciation de variables dont la valeur sera stockée dans la blockchain et ces variables ne pourront être modifier que par l'appels de fonctions/du constructeur du smart contract.


SUITE 2


Nouvelle idée : fixer un seuil que l'ont veut atteindre pour cela modifier le contrat

Pour cela on va tout d'abord définir une nouvelle valeur,  ajouter une nouvelle ligne : `uint public objectif;` et l'instancier à 100000000000000000 dans le constructeur mais également ajouter une nouvelle ligne dans la fonction retirer : `assert(this.balance >= objectif)` si l'argent disponible dans l'épargne n'est pas suffisant...PAs de retrait possible

Ceci montre que si les termes d'un accord (quel qu'il soit) ne sont pas remplis, il ne pourra pas se dérouler. De plus la valeur objectif est impossible à modifier une fois instanciée et est fixée poour toujours, pour le modifier il faudrait modifier le code et donc instancier un nouveau contrat avec une nouvelle adresse sans rapport avec celui ci...les ether stockés ici seront donc perdus !


Suite 2 :

Smart contract ouvert, ainsi avec l'adresse n'importe quel noeud du réseau peut y accéder, de plus avec fonctions en pubic, tout le monde peut y accéder, comme le montre

après avoir versé de l'argent à un des autres users du noeud 1 ou 2 : `eth.sendTransaction({from:eth.accounts[0], to:"0xe80493e84125f72fddda65d041b4681e797ed3f5", value:50000000000000000})` (sans argent il ne pourra pas payer le miner et par conséquent pas effectuer de transaction), avec ce user, videz le contenu du smart contract `tirelireTx.retirer({from:"ADDRESS"})`

 ainsi un être malveillant pourrait aisément dérober le contenu de notre tirelire....

Pour cette raison on va mettre en place un peu de sécurité, seul l'émétteur du smart contract sera en mesure de le modifier, pour cela on instancie un nouvel élément 'address owner' à `msg.sender` dans le constructeur, et on ajoute dans la fonction retirer l'assert permettant de vérifier que l'adresse correspond bien à l'adresse du créateur du smart contract

Sécurité très imp pour prévenir les accès
!!!

Nombreux autres types d'applis possibles, comme déjà dit, notamment propriété ou notariat, exemple : https://github.com/toluhi/property-developer
