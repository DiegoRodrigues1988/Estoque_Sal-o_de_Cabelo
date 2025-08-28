import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/providers/cliente_provider.dart';
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Cliente>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    // --- CORREÇÃO AQUI ---
    // Usamos 'addPostFrameCallback' para garantir que a tela esteja construída
    // antes de tentarmos carregar os dados do Provider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvents();
    });
  }

  // Função para carregar os "eventos" (clientes que visitaram)
  void _loadEvents() {
    final clientes =
        Provider.of<ClienteProvider>(context, listen: false).clientes;
    final Map<DateTime, List<Cliente>> eventsForMonth = {};

    for (var cliente in clientes) {
      // Normaliza a data para ignorar a hora, usando UTC para consistência
      final eventDay = DateTime.utc(cliente.ultimaVisita.year,
          cliente.ultimaVisita.month, cliente.ultimaVisita.day);

      if (eventsForMonth[eventDay] == null) {
        eventsForMonth[eventDay] = [];
      }
      eventsForMonth[eventDay]!.add(cliente);
    }
    setState(() {
      _events = eventsForMonth;
    });
  }

  List<Cliente> _getEventsForDay(DateTime day) {
    // Normaliza o dia para a busca, usando UTC
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final clientesDoMes = _events.values
        .expand((element) => element)
        .where((c) =>
            c.ultimaVisita.month == _focusedDay.month &&
            c.ultimaVisita.year == _focusedDay.year)
        .toList();

    final eventosDoDiaSelecionado =
        _getEventsForDay(_selectedDay ?? DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda e Histórico de Visitas'),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                // Recarrega os eventos para o novo mês visível
                _loadEvents();
              });
            },
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber[800],
                      ),
                      width: 18.0,
                      height: 18.0,
                      child: Center(
                        child: Text(
                          '${events.length}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Total de clientes atendidos este mês: ${clientesDoMes.length}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
              "Atendimentos em ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: eventosDoDiaSelecionado.isEmpty
                ? const Center(child: Text("Nenhum atendimento neste dia."))
                : ListView.builder(
                    itemCount: eventosDoDiaSelecionado.length,
                    itemBuilder: (context, index) {
                      final cliente = eventosDoDiaSelecionado[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.cut),
                          title: Text(cliente.nome),
                          trailing: Text(
                              "às ${DateFormat('HH:mm').format(cliente.ultimaVisita)}"),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
