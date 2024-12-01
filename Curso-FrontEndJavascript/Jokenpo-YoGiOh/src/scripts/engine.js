const state ={
    score:{
        playerScore:0,
        computerScore:0,
        scoreBox:document.getElementById("score_points")
    },
    cardSprites:{
        avatar:document.getElementById("card-image"),
        name:document.getElementById("card-name"),
        type:document.getElementById("card-type"),
    },
    fieldcards:{
        player:document.getElementById("player-field-card"),
        computer:document.getElementById("computer-field-card"),

    },
    actions:{
        button:document.getElementById("next-duel"),
    },
    playerSides:{
        player1:"player-cards",
        player1Box: document.querySelector("#player-cards"),
        computer:"computer-cards",
        computerBox:document.querySelector("#computer-cards"),
    }
    
};
const pathImages = "./src/assets/icons/";
const cardData = [
    {
        id:0,
        name:"Blue Eyes White Dragon",
        type:"Papel",
        img: `${pathImages}dragon.png`,
        Winof:[1],
        LoseOf:[2],
    },
    {
        id:1,
        name:"Dark Magician",
        type:"Pedra",
        img: `${pathImages}magician.png`,
        Winof:[2],
        LoseOf:[0],
    },
    {
        id:2,
        name:"Exodia",
        type:"Tesoura",
        img: `${pathImages}exodia.png`,
        Winof:[0],
        LoseOf:[1],
    },
];

async function getRandomCardId() {
    const  randomIndex = Math.floor(Math.random() * cardData.length);
    
   return cardData[randomIndex].id;
   
}

async function createCardImage(IdCard,fieldSide){
    const cardImage = document.createElement("img");
    cardImage.setAttribute("height","100px");
    cardImage.setAttribute("src","./src/assets/icons/card-back.png");
    cardImage.setAttribute("data-id",IdCard);
    cardImage.classList.add("card");
    if(fieldSide===state.playerSides.player1){
        cardImage.addEventListener("mouseover",()=>{
            drawSelectCard(IdCard);
        });
        cardImage.addEventListener("click",()=>{
            setCardsField(cardImage.getAttribute("data-id"))
        });
    }
    return cardImage;
};


async function setCardsField(cardId) {
    await removeAllCardsImages();
    let computerCardId = await getRandomCardId();
    state.fieldcards.player.style.display="block";
    state.fieldcards.player.src = cardData[cardId].img;
    state.fieldcards.computer.src = cardData[computerCardId].img;
    state.fieldcards.computer.style.display="block";
    state.cardSprites.name.innerText="";
    state.cardSprites.type.innerText="";
    let duelResults = await checkDuelResults(cardId,computerCardId);
    await updateScore();
    await drawButton(duelResults);
};
async function drawButton(text) {
    state.actions.button.innerText=text;
    state.actions.button.style.display="block";
}

async function updateScore() {
    state.score.scoreBox.innerText =  `Vitórias : ${state.score.playerScore} |     Derrotas : ${state.score.computerScore} `;
    
}
async function resetDuel(){
    state.cardSprites.avatar.src =  "";
    state.actions.button.style.display = "none";
    state.fieldcards.player.style.display = "none";
    state.fieldcards.computer.style.display = "none";
    init();

}
async function checkDuelResults(playerCardID,ComputerCardId) {
    console.log(`Player (${cardData[playerCardID].id}): ${cardData[playerCardID].Winof} `);
    console.log(`PC(${cardData[ComputerCardId].id}): ${cardData[ComputerCardId].Winof} `);

    let duelResults="Empate";
    if (cardData[ComputerCardId].Winof==playerCardID) {
        duelResults="Você Perdeu!!!";
        state.score.computerScore++;
        await playAudio("lose");
    }
    if(cardData[playerCardID].Winof==ComputerCardId) {
        duelResults="Você Ganhou!!!";
        state.score.playerScore++;
        await playAudio("Win");
    }
   
    return duelResults
}
async function removeAllCardsImages(){
    let {computerBox,player1Box} = state.playerSides;
    let imgElemnts = computerBox.querySelectorAll("img");
    imgElemnts.forEach((img)=>img.remove());

    imgElemnts = player1Box.querySelectorAll("img");
    imgElemnts.forEach((img)=>img.remove());

}  
async function playAudio(status){
 const audio = new Audio(`./src/assets/audios/${status}.wav`);
 audio.play();
} 

async function drawSelectCard(index){
    state.cardSprites.avatar.src= cardData[index].img;
    state.cardSprites.name.innerText= cardData[index].name;
    state.cardSprites.type.innerText= "Atributo:" + cardData[index].type;
}

async function drawCards(cardNumbers,fieldSide) {
    for (let i = 0; i < cardNumbers;i++ ) {
        const randomIdcard = await getRandomCardId();
        const cardImage = await createCardImage(randomIdcard,fieldSide);
        document.getElementById(fieldSide).appendChild(cardImage);
    }

}


function init(){
    drawCards(5,state.playerSides.player1);
    drawCards(5,state.playerSides.computer);
}

init();

