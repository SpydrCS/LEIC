#include "carrinhoTransporte.h"
#include <string>
#include <utility>

using namespace std;

CarrinhoTransporte::CarrinhoTransporte(unsigned int c1, unsigned int n1, unsigned int m1, string m2, unsigned c,
                                       unsigned n, unsigned int m) : Voo(c1, n1, m1, std::move(m2)) {
    carruagens = c;
    pilhas = n;
    malas = m;
    maxMalas = c*n*m;
}
unsigned CarrinhoTransporte::getPilhas() const {
    return pilhas;
}
unsigned CarrinhoTransporte::getCarruagens() const {
    return carruagens;
}
unsigned int CarrinhoTransporte::getMalas() const {
    return malas;
}
unsigned int CarrinhoTransporte::getMaxMalas() const {
    return maxMalas;
}
void CarrinhoTransporte::malasIntoCarrinho() {
    for (auto i : vector_carruagens) {
        for (auto j : vector_pilhas) {
            if (j.size() < malas) {
                j.push_back(bagagensVoo.top());
                bagagensVoo.pop();
            }
        }
    }
}
