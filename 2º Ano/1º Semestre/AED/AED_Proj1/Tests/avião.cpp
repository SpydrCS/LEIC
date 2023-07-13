#include "avião.h"

Aviao::Aviao(string m) {
    matricula = std::move(m);
}
void Aviao::setTipo(string t) {
    tipo = t;
}
void Aviao::setCapacidade(unsigned int c) {
    capacidade = c;
}
void Aviao::addVoo(Voo v) {
    planoVoo.push_back(v);
}
void Aviao::removeVoo(Voo v) {
    planoVoo.remove(v);
}
string Aviao::getMatricula() {
    return matricula;
}
string Aviao::getTipo() {
    return tipo;
}
unsigned int Aviao::getCapacidade() const {
    return capacidade;
}
