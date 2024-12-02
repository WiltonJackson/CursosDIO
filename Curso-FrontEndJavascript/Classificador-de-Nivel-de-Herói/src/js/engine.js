function verificarNivel() {
    // Obter os valores do nome e XP dos inputs
    var nome = document.getElementById("nome").value;
    var xp = parseInt(document.getElementById("xp").value);

    // Validar se os campos foram preenchidos
    if (!nome || isNaN(xp)) {
        document.getElementById("resultado").innerHTML = "Por favor, preencha todos os campos corretamente.";
        return;
    }

    // Variável para armazenar o nível
    var nivel = "";

    // Estrutura de decisão para determinar o nível com base na XP
    if (xp < 1000) {
        nivel = "Ferro";
    } else if (xp >= 1001 && xp <= 2000) {
        nivel = "Bronze";
    } else if (xp >= 2001 && xp <= 5000) {
        nivel = "Prata";
    } else if (xp >= 5001 && xp <= 7000) {
        nivel = "Ouro";
    } else if (xp >= 7001 && xp <= 8000) {
        nivel = "Platina";
    } else if (xp >= 8001 && xp <= 9000) {
        nivel = "Ascendente";
    } else if (xp >= 9001 && xp <= 10000) {
        nivel = "Imortal";
    } else if (xp > 10000) {
        nivel = "Radiante";
    }

    // Exibir a mensagem com o nome e nível
    document.getElementById("resultado").innerHTML = `O Herói de nome <strong>${nome}</strong> está no nível de <strong>${nivel}</strong>`;
}
