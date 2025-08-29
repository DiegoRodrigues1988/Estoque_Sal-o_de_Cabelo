import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

// --- IMPORTAÇÕES CORRIGIDAS ---
import 'package:estoque_salao_de_cabelo/providers/cliente_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/agendamento_provider.dart';
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';
import 'package:estoque_salao_de_cabelo/models/agendamento_model.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<Agendamento> _getEventsForDay(BuildContext context, DateTime day) {
    final provider = Provider.of<AgendamentoProvider>(context, listen: false);
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);

    return provider.agendamentos.where((agendamento) {
      final agendamentoDay = DateTime.utc(
          agendamento.data.year, agendamento.data.month, agendamento.data.day);
      return isSameDay(agendamentoDay, normalizedDay);
    }).toList();
  }

  Future<void> _mostrarDialogoNovoAgendamento() async {
    final Cliente? clienteSelecionado = await showDialog(
      context: context,
      builder: (_) => const _DialogoSelecaoCliente(),
    );
    if (clienteSelecionado == null || !mounted) return;

    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _selectedDay ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (dataSelecionada == null || !mounted) return;

    final horaSelecionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (horaSelecionada == null || !mounted) return;

    final dataHoraFinal = DateTime(
      dataSelecionada.year,
      dataSelecionada.month,
      dataSelecionada.day,
      horaSelecionada.hour,
      horaSelecionada.minute,
    );

    final provider = Provider.of<AgendamentoProvider>(context, listen: false);
    await provider.addAgendamento(clienteSelecionado, dataHoraFinal);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${clienteSelecionado.nome} agendado!'),
            backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AgendamentoProvider>(
      builder: (context, provider, child) {
        final eventosDoDia =
            _getEventsForDay(context, _selectedDay ?? DateTime.now());

        return Scaffold(
          appBar: AppBar(title: const Text('Agenda')),
          floatingActionButton: FloatingActionButton(
            onPressed: _mostrarDialogoNovoAgendamento,
            child: const Icon(Icons.add),
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
                onDaySelected: (selectedDay, focusedDay) => setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                }),
                onPageChanged: (focusedDay) =>
                    setState(() => _focusedDay = focusedDay),
                eventLoader: (day) => _getEventsForDay(context, day),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      final agendamentos = events.cast<Agendamento>();
                      bool agendado =
                          agendamentos.any((e) => e.status == 'agendado');
                      bool concluido =
                          agendamentos.any((e) => e.status == 'concluido');

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (concluido) _buildMarker(Colors.amber[800]!),
                          if (agendado) _buildMarker(Colors.green),
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
                    ? const Center(
                        child: Text("Nenhum agendamento para este dia."))
                    : ListView.builder(
                        itemCount: eventosDoDia.length,
                        itemBuilder: (context, index) {
                          final agendamento = eventosDoDia[index];
                          return _buildAgendamentoTile(context, agendamento);
                        },
                      ),
              ),
            ],
          ),
        );
      },
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

  Widget _buildAgendamentoTile(BuildContext context, Agendamento agendamento) {
    IconData icon = Icons.help_outline;
    Color color = Colors.grey;
    String statusText = 'Desconhecido';

    switch (agendamento.status) {
      case 'concluido':
        icon = Icons.check_circle;
        color = Colors.amber;
        statusText = 'Concluído';
        break;
      case 'cancelado':
        icon = Icons.cancel;
        color = Colors.grey;
        statusText = 'Cancelado';
        break;
      case 'agendado':
        icon = Icons.calendar_today;
        color = Colors.green;
        statusText = 'Agendado';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: color.withOpacity(0.2),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(agendamento.clienteNome),
        subtitle: Text(
            "$statusText às ${DateFormat('HH:mm').format(agendamento.data)}"),
        onTap: () => _mostrarOpcoes(context, agendamento),
      ),
    );
  }

  void _mostrarOpcoes(BuildContext context, Agendamento agendamento) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(agendamento.clienteNome),
        content: const Text('O que você deseja fazer com este agendamento?'),
        actions: [
          if (agendamento.status == 'agendado')
            TextButton(
              child: const Text('Concluir Atendimento'),
              onPressed: () {
                Provider.of<AgendamentoProvider>(context, listen: false)
                    .concluirAgendamento(agendamento);
                Navigator.of(ctx).pop();
              },
            ),
          if (agendamento.status == 'agendado')
            TextButton(
              child: const Text('Cancelar Agendamento'),
              onPressed: () {
                Provider.of<AgendamentoProvider>(context, listen: false)
                    .cancelarAgendamento(agendamento);
                Navigator.of(ctx).pop();
              },
            ),
          TextButton(
            child: const Text('Excluir Registro',
                style: TextStyle(color: Colors.red)),
            onPressed: () {
              Provider.of<AgendamentoProvider>(context, listen: false)
                  .deleteAgendamento(agendamento);
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Fechar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }
}

class _DialogoSelecaoCliente extends StatelessWidget {
  const _DialogoSelecaoCliente();

  @override
  Widget build(BuildContext context) {
    final clientes = Provider.of<ClienteProvider>(context).clientes;
    return AlertDialog(
      title: const Text('Selecione um Cliente'),
      content: SizedBox(
        width: double.maxFinite,
        child: clientes.isEmpty
            ? const Center(child: Text('Nenhum cliente cadastrado.'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: clientes.length,
                itemBuilder: (ctx, index) {
                  final cliente = clientes[index];
                  return ListTile(
                    title: Text(cliente.nome),
                    onTap: () {
                      Navigator.of(ctx).pop(cliente);
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
