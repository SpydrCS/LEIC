#include "serviço.h"

void Servico::addServico(Servico s) {
    servicos.push(s);
}
void Servico::removeServico(Servico serv) {
    queue<Servico> ref;
    while (!servicos.empty()) {
        if (servicos.front().data == serv.data and servicos.front().funcionario == serv.funcionario and servicos.front().tipo == serv.tipo)
            servicos.pop();
        else {
            ref.push(servicos.front());
            servicos.pop();
        }
    }
    while(!ref.empty()) {
        servicos.push(ref.front());
        ref.pop();
    }
}
void Servico::moveServicoParaRealizado(Servico s) {
    removeServico(s);
    servicosRealizados.push(s);
}
void Servico::removeServicoRealizado(Servico s) {
    queue<Servico> ref;
    while (!servicosRealizados.empty()) {
        if (servicosRealizados.front().data == s.data and servicosRealizados.front().funcionario == s.funcionario and servicosRealizados.front().tipo == s.tipo)
            servicosRealizados.pop();
        else {
            ref.push(servicosRealizados.front());
            servicosRealizados.pop();
        }
    }
    while(!ref.empty()) {
        servicosRealizados.push(ref.front());
        ref.pop();
    }
}

Servico::Servico(string t, string d, string f, Aviao a) {
    tipo = t;
    data = d;
    funcionario = f;
}