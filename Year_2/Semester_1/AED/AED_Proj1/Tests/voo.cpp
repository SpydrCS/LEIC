#include "voo.h"

#include <utility>

Voo::Voo(unsigned int c, unsigned int n, unsigned int m1, string m) : CarrinhoTransporte(0, 0, 0, std::string(), c, n,
                                                                                         m1), Aviao(std::move(m)) {
    vagas = capacidade;
};
bool Voo::addBagagem(const Bagagens& b) {
    if (bagagensVoo.size() < maxMalas) {
        bagagensVoo.push(b);
    return true;
    }
    return false;
}
bool Voo::removeBagagem(Bagagens b) {
    int size = bagagensVoo.size();
    stack<Bagagens> extra;
    while(!bagagensVoo.empty()) {
        Bagagens st = bagagensVoo.top();
        if (st.getDono() == b.getDono()) {
            bagagensVoo.pop();
        }
        else {
            extra.push(st);
            bagagensVoo.pop();
        }
    }
    if (size == extra.size())
        return false;
    while(!extra.empty()) {
        bagagensVoo.push(extra.top());
        extra.pop();
    }
    return true;
}
void Voo::setNumero(unsigned int n) {
    numero = n;
}
void Voo::setDataPartida(string dp) {
    data_partida = std::move(dp);
}
void Voo::setDuracao(unsigned int d) {
    duracao = d;
}
void Voo::setOrigem(string o) {
    origem = std::move(o);
}
void Voo::setDestino(string de) {
    destino = std::move(de);
}
void Voo::setVagas(unsigned v) {
    vagas = v;
}
unsigned int Voo::getNumero() const {
    return numero;
}
string Voo::getDataPartida() {
    return data_partida;
}
unsigned int Voo::getDuracao() const {
    return duracao;
}
string Voo::getOrigem() {
    return origem;
}
string Voo::getDestino() {
    return destino;
}
unsigned int Voo::getVagas() const {
    return vagas;
}