#ifndef AED_PROJ1_VOO_H
#define AED_PROJ1_VOO_H

#include <string>
#include <stack>
#include <vector>
#include "bagagens.h"
#include "carrinhoTransporte.h"

using namespace std;

class Voo : public Aviao, CarrinhoTransporte{
public:
    Voo(unsigned int c, unsigned int n, unsigned int m1, string m);
    stack<Bagagens> bagagensVoo;
    bool addBagagem(const Bagagens& b);
    bool removeBagagem( Bagagens b);
    void setNumero(unsigned n);
    void setDataPartida(string dp);
    void setDuracao(unsigned d);
    void setOrigem(string o);
    void setDestino(string de);
    void setVagas(unsigned v);
    unsigned getNumero() const;
    string getDataPartida();
    unsigned getDuracao() const;
    string getOrigem();
    string getDestino();
    unsigned getVagas() const;
    unsigned vagas;
    unsigned numero;
private:
    string data_partida;
    unsigned duracao;
    string origem;
    string destino;
};


#endif //AED_PROJ1_VOO_H