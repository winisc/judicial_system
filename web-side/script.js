let valorInputId = 0
let esc = true

window.addEventListener("message", ({ data }) => {
    if (!data) {
        return
    }

    if (data.action === "open") {
        document.querySelector(".container-busca").style.display = 'flex';
    }

    if (data.action === "close") {
        document.querySelector(".container-busca").style.display = 'none';
        document.querySelector(".container-info").style.display = 'none';
    }

    if (data.action === "nil") {
        esc = false
        document.querySelector(".container-busca").style.display = 'none';
        document.querySelector(".container-info").style.display = 'none';
        document.querySelector(".container-info-nil").style.display = 'flex';
        setTimeout(() => {
            document.querySelector(".container-info-nil").style.display = 'none';
            document.querySelector(".container-busca").style.display = 'flex';
            esc = true
        }, "1000");
    }

    if (data.action === "query") {
        const dataGet = data.data
        atualizarInfos(dataGet)
    }

})

function buscar() {
    valorInputID = document.querySelector("#input-busca").value;

    if (!/^\d{1,4}$/.test(valorInputID)) {
        return;
    }

    idData(valorInputID)
    document.querySelector(".container-busca").style.display = 'none';

    document.querySelector("#input-busca").value = '';
}

function closeSystem(){
    fetch('https://sistema_judiciario/close', { method: 'POST' });
}

function idData(id){
    setTimeout(() => {
        fetch('https://sistema_judiciario/toReceive', {
            method: 'POST',
            body: id,
            headers: { 'Content-Type': 'application/json' }
        });
    }, "300");
}

function atualizarInfos(data) {
    document.querySelector(".container-info").style.display = 'flex';

    document.querySelector(".info span:nth-child(2)").textContent = `${data.name} ${data.name2}`;

    document.querySelector(".info span:nth-child(4)").textContent = data.passaport;

    const armaSpan = document.querySelector("#arma span");
    armaSpan.textContent = data.port ? "SIM" : "NÃO";
    armaSpan.style.color = data.port ? "rgba(186, 255, 154, 1)" : "rgba(255, 154, 154, 1)";

    const aereaSpan = document.querySelector("#aerea span");
    aereaSpan.textContent = data.aerea ? "SIM" : "NÃO";
    aereaSpan.style.color = data.aerea ? "rgba(186, 255, 154, 1)" : "rgba(255, 154, 154, 1)";

    const reuSpan = document.querySelector("#reu span");
    reuSpan.textContent = data.reuPrimario ? "SIM" : "NÃO";
    reuSpan.style.color = data.reuPrimario ? "rgba(186, 255, 154, 1)" : "rgba(255, 154, 154, 1)";
}


document.addEventListener('keydown', function(event) {
    if (event.key === "Escape" && esc) { 
        closeSystem();  
    }
});