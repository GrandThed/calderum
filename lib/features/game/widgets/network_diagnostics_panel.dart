import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sync_model.dart';
import '../providers/game_providers.dart';
import '../../../shared/theme/app_theme.dart';
import 'network_status_widget.dart';
import 'lag_compensation_widget.dart';

/// Comprehensive network diagnostics panel
class NetworkDiagnosticsPanel extends ConsumerStatefulWidget {
  const NetworkDiagnosticsPanel({super.key});

  @override
  ConsumerState<NetworkDiagnosticsPanel> createState() => _NetworkDiagnosticsPanelState();
}

class _NetworkDiagnosticsPanelState extends ConsumerState<NetworkDiagnosticsPanel>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.network_check,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Network Diagnostics',
                  style: AppTheme.titleStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Tab bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Status'),
              Tab(text: 'Performance'),
              Tab(text: 'History'),
            ],
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppTheme.primaryColor,
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStatusTab(),
                _buildPerformanceTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTab() {
    final connectionStatus = ref.watch(connectionStatusProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Current status
          NetworkStatusWidget(
            showDetailed: true,
            padding: EdgeInsets.zero,
          ),

          const SizedBox(height: 24),

          // Connection details
          _buildConnectionDetails(connectionStatus),

          const SizedBox(height: 24),

          // Server info
          _buildServerInfo(),

          const SizedBox(height: 24),

          // Action buttons
          _buildActionButtons(connectionStatus),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Lag compensation widget
          const LagCompensationWidget(showDetailed: true),

          const SizedBox(height: 24),

          // Performance metrics
          _buildPerformanceMetrics(),

          const SizedBox(height: 24),

          // Quality indicators
          _buildQualityIndicators(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Connection history
          _buildConnectionHistory(),

          const SizedBox(height: 24),

          // Error logs
          _buildErrorLogs(),
        ],
      ),
    );
  }

  Widget _buildConnectionDetails(ConnectionStatus status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connection Details',
            style: AppTheme.titleStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildDetailRow('Protocol', 'WebSocket'),
          _buildDetailRow('Server', 'us-central1.gameserver.dev'),
          _buildDetailRow('Region', 'US Central'),
          _buildDetailRow('Port', '443 (SSL)'),
          _buildDetailRow('Encryption', 'TLS 1.3'),
          _buildDetailRow('Session ID', 'sess_abcd1234'),
        ],
      ),
    );
  }

  Widget _buildServerInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Server Information',
            style: AppTheme.titleStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildDetailRow('Server Load', 'Normal (23%)'),
          _buildDetailRow('Active Players', '1,247'),
          _buildDetailRow('Uptime', '99.9%'),
          _buildDetailRow('Version', '2.1.4'),
          _buildDetailRow('Last Restart', '2 days ago'),
          _buildDetailRow('Maintenance', 'Scheduled: None'),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ConnectionStatus status) {
    return Column(
      children: [
        // Test connection
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _runConnectionTest(),
            icon: const Icon(Icons.speed_rounded),
            label: const Text('Run Speed Test'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Force refresh
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _forceRefresh(),
            icon: const Icon(Icons.refresh),
            label: const Text('Force Refresh'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),

        if (status == ConnectionStatus.error) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _resetConnection(),
              icon: const Icon(Icons.settings_backup_restore),
              label: const Text('Reset Connection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPerformanceMetrics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: AppTheme.titleStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Metrics grid
          Row(
            children: [
              Expanded(
                child: _buildMetricCard('Packet Loss', '0.1%', Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard('Jitter', '2.3ms', Colors.blue),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildMetricCard('Bandwidth', '2.1 MB/s', Colors.purple),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard('CPU Usage', '12%', Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityIndicators() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quality Indicators',
            style: AppTheme.titleStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          _buildQualityBar('Connection', 0.9, Colors.green),
          const SizedBox(height: 8),
          _buildQualityBar('Stability', 0.85, Colors.blue),
          const SizedBox(height: 8),
          _buildQualityBar('Responsiveness', 0.75, Colors.orange),
          const SizedBox(height: 8),
          _buildQualityBar('Reliability', 0.95, Colors.green),
        ],
      ),
    );
  }

  Widget _buildConnectionHistory() {
    final connectionEvents = [
      {'time': '14:32:15', 'event': 'Connected', 'status': 'success'},
      {'time': '14:31:58', 'event': 'Reconnecting...', 'status': 'warning'},
      {'time': '14:31:52', 'event': 'Connection lost', 'status': 'error'},
      {'time': '14:29:03', 'event': 'Connected', 'status': 'success'},
      {'time': '14:28:55', 'event': 'Game started', 'status': 'info'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connection History',
            style: AppTheme.titleStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          ...connectionEvents.map((event) => _buildHistoryItem(event)),
        ],
      ),
    );
  }

  Widget _buildErrorLogs() {
    final errorLogs = [
      {'time': '14:31:52', 'error': 'WebSocket connection timeout', 'code': 'NET_001'},
      {'time': '14:15:23', 'error': 'Packet drop detected', 'code': 'NET_002'},
      {'time': '14:02:11', 'error': 'High latency warning', 'code': 'LAG_001'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Error Logs',
            style: AppTheme.titleStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          if (errorLogs.isEmpty)
            Text(
              'No errors recorded',
              style: AppTheme.bodyStyle.copyWith(
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            ...errorLogs.map((error) => _buildErrorItem(error)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: AppTheme.bodyStyle.copyWith(color: Colors.white70),
          ),
          Text(
            value,
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.titleStyle.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTheme.bodyStyle.copyWith(color: Colors.white70),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: AppTheme.bodyStyle.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, String> event) {
    Color statusColor;
    IconData statusIcon;

    switch (event['status']) {
      case 'success':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'warning':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case 'error':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = Icons.info;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 8),
          Text(
            event['time']!,
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              event['event']!,
              style: AppTheme.bodyStyle.copyWith(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorItem(Map<String, String> error) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, size: 16, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  error['error']!,
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      error['time']!,
                      style: AppTheme.bodyStyle.copyWith(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      error['code']!,
                      style: AppTheme.bodyStyle.copyWith(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _runConnectionTest() {
    // Show loading indicator and simulate speed test
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speed test completed: 45ms latency, Good connection'),
        ),
      );
    });
  }

  void _forceRefresh() {
    ref.read(connectionStatusProvider.notifier).updateStatus(
      ConnectionStatus.syncing,
    );

    Future.delayed(const Duration(seconds: 1), () {
      ref.read(connectionStatusProvider.notifier).updateStatus(
        ConnectionStatus.connected,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connection refreshed')),
    );
  }

  void _resetConnection() {
    ref.read(connectionStatusProvider.notifier).updateStatus(
      ConnectionStatus.syncing,
    );

    Future.delayed(const Duration(seconds: 2), () {
      ref.read(connectionStatusProvider.notifier).updateStatus(
        ConnectionStatus.connected,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connection reset')),
    );
  }
}