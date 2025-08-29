import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/providers/cliente_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/agendamento_provider.dart';
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';
import 'package:estoque_salao_de_cabelo/models/agendamento_model.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvents();
    });
  }

  void _loadEvents() {
    final clientes =
        Provider.of<ClienteProvider>(context, listen: false).clientes;
    final agendamentos =
        Provider.of<AgendamentoProvider>(context, listen: false).agendamentos;
    final Map<DateTime, List<dynamic>> events = {};

    for (var cliente in clientes) {
      final eventDay = DateTime.utc(cliente.ultimaVisita.year,
          cliente.ultimaVisita.month, cliente.ultimaVisita.day);
      if (events[eventDay] == null) events[eventDay] = [];
      events[eventDay]!.add(cliente);
    }
    for (var agendamento in agendamentos) {
      final eventDay = DateTime.utc(
          agendamento.data.year, agendamento.data.month, agendamento.data.day);
      if (events[eventDay] == null) events[eventDay] = [];
      events[eventDay]!.add(agendamento);
    }

    if (mounted) {
      setState(() => _events = events);
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  // --- NOVA FUNÇÃO PARA EXCLUIR AGENDAMENTOS ---
  void _confirmarExclusao(BuildContext context, Agendamento agendamento) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
            'Deseja excluir o agendamento de "${agendamento.clienteNome}"?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            onPressed: () {
              final provider =
                  Provider.of<AgendamentoProvider>(context, listen: false);
              provider.deleteAgendamento(agendamento).then((_) {
                _loadEvents(); // Recarrega os eventos para atualizar o calendário
              });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventosDoDia = _getEventsForDay(_selectedDay ?? DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Agenda')),
      body: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) => setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            }),
            onPageChanged: (focusedDay) =>
                setState(() => _focusedDay = focusedDay),
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  bool temAgendamento = events.any((e) => e is Agendamento);
                  bool temVisita = events.any((e) => e is Cliente);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (temVisita) _buildMarker(Colors.amber[800]!),
                      if (temAgendamento) _buildMarker(Colors.green),
                    ],
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: eventosDoDia.isEmpty
                ? const Center(child: Text("Nenhum registro para este dia."))
                : ListView.builder(
                    itemCount: eventosDoDia.length,
                    itemBuilder: (context, index) {
                      final evento = eventosDoDia[index];
                      if (evento is Cliente) {
                        return _buildVisitaTile(evento);
                      }
                      if (evento is Agendamento) {
                        return _buildAgendamentoTile(context, evento);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildVisitaTile(Cliente cliente) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.amber.withOpacity(0.2),
      child: ListTile(
        leading: const Icon(Icons.cut, color: Colors.amber),
        title: Text(cliente.nome),
        subtitle: const Text("Visitou"),
        trailing:
            Text("às ${DateFormat('HH:mm').format(cliente.ultimaVisita)}"),
      ),
    );
  }

  Widget _buildAgendamentoTile(BuildContext context, Agendamento agendamento) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.green.withOpacity(0.2),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.green),
        title: Text(agendamento.clienteNome),
        subtitle: const Text("Agendado"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("às ${DateFormat('HH:mm').format(agendamento.data)}"),
            // --- BOTÃO DE LIXEIRA ADICIONADO AQUI ---
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _confirmarExclusao(context, agendamento),
            )
          ],
        ),
      ),
    );
  }
}
