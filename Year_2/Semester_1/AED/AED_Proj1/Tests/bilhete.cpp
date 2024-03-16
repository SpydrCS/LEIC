#include "bilhete.h"

#include <utility>

using namespace std;

Bilhete::Bilhete(string m, bool cA, bool b, string nD, unsigned int q_bag, unsigned int q_bilh) : Voo(0, 0, 0, m) {
    checkinAutomatico = cA;
    bagagens=b;
    nomeDono = std::move(nD);
    quantidade_bagagens=q_bag;
    quantidade_bilhetes=q_bilh;
}
bool Bilhete::getCheckInAutomatico() const {
    return checkinAutomatico;
}
bool Bilhete::getBagagens() const {
    return bagagens;
}
string Bilhete::getNomeDono() {
    return nomeDono;
}
unsigned int Bilhete::getQuantidadeBagagens() const {
    if (bagagens)
        return quantidade_bagagens;
    return 0;
}
unsigned int Bilhete::getQuantidadeBilhetes() const {
    return quantidade_bilhetes;
}
void Bilhete::updateVagas() {
    if (BilheteValido())
        vagas -= quantidade_bilhetes;
}
bool Bilhete::BilheteValido() {
    if (vagas - quantidade_bilhetes < 0)
        return false;
    return true;
}