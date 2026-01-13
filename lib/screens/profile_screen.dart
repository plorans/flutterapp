import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'tournament_stats_screen.dart';
import '../services/imagenes_service.dart';

class ProfileScreen extends StatelessWidget {
  final int userId;
  final String username;
  final String email;
  final String collectorTag;
  final String bio;
  final String joinDate;
  final double credit;
  final List<dynamic> achievements;
  final List<dynamic> subscriptions;
  final String avatar;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.username,
    required this.email,
    required this.collectorTag,
    required this.bio,
    required this.joinDate,
    required this.credit,
    required this.achievements,
    required this.subscriptions,
    required this.avatar,
  });

  Map<String, String> getSubscriptionLevels() {
    return {
      '0': 'BYTE SEEKER',
      '200': 'PIXEL KNIGHT',
      '500': 'REALM SORCERER',
      '1500': 'LEGENDARY GUARDIAN',
      '3000': 'COSMIC OVERLORD',
    };
  }

  Map<String, dynamic>? getActiveSubscription() {
    final activeSubs = subscriptions
        .where((sub) => sub['status'] == 'active')
        .toList();

    if (activeSubs.isEmpty) return null;

    final sub = activeSubs.first;
    final levels = getSubscriptionLevels();

    double totalDouble = double.tryParse(sub['total'].toString()) ?? 0;
    String totalStr = totalDouble.toInt().toString();

    String name = levels[totalStr] ?? 'Suscripción Activa';

    return {
      'id': sub['id'],
      'status': sub['status'],
      'total': sub['total'],
      'start': sub['start'],
      'next_payment': sub['next_payment'], 
      'name': name,
    };
  }

  String getSubscriptionImage(String name) {
    switch (name) {
      case 'BYTE SEEKER':
        return "assets/images/ByteSeeker.png";
      case 'PIXEL KNIGHT':
        return "assets/images/PixelKnight.png";
      case 'REALM SORCERER':
        return "assets/images/RealmSorcerer.png";
      case 'LEGENDARY GUARDIAN':
        return "assets/images/LegendaryGuardian.png";
      case 'COSMIC OVERLORD':
        return "assets/images/CosmicOverlord.png";
      default:
        return "assets/images/ByteSeeker.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeSubscription = getActiveSubscription();
    final subscriberName = activeSubscription?['name'] ?? "BYTE SEEKER";
    final subscriptionImage = getSubscriptionImage(subscriberName);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // HEADER SECTION
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFFA75B),
                    const Color(0xFFFF8A00),
                    const Color(0xFFFF6B00),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón de configuración
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.settings,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Avatar e información
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AvatarWidget(avatarUrl: avatar),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              collectorTag,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(0.8),
                                letterSpacing: 1.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "CRÉDITO \$${credit.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Sección de torneos y membresía SIN RECUADROS
                  SizedBox(
                    height: 220,
                    child: Stack(
                      children: [
                        // LEFT: Actions (constrained)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: const _TournamentActions(),
                          ),
                        ),

                        // RIGHT: Membership image (floating)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Transform.translate(
                            offset: const Offset(
                              30,
                              0,
                            ), 
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: _MembershipImage(
                                subscriptionImage: subscriptionImage,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // STATS SECTION (mantiene recuadro)
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              color: Colors.black,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem("Victorias", "0"),
                    _VerticalDivider(),
                    _StatItem("Win Rate", "0%"),
                    _VerticalDivider(),
                    _StatItem("Torneos", "0"),
                  ],
                ),
              ),
            ),
          ),

          // ACHIEVEMENTS SECTION
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 40,
              ),
              color: Colors.black,
              child: Column(
                children: [
                  Text(
                    "LOGROS Y TROFEOS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _AchievementsWidget(achievements: achievements),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: Colors.orange.withOpacity(0.3),
    );
  }
}

class _AvatarWidget extends StatefulWidget {
  final String avatarUrl;

  const _AvatarWidget({required this.avatarUrl});

  @override
  State<_AvatarWidget> createState() => __AvatarWidgetState();
}

class __AvatarWidgetState extends State<_AvatarWidget> {
  Uint8List? _avatarBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    if (widget.avatarUrl.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final imageBytes = await ImageService.downloadImage(widget.avatarUrl);
      setState(() {
        _avatarBytes = imageBytes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando avatar: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.orange, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: ClipOval(
        child: _isLoading
            ? Container(
                color: Colors.grey[800],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                    strokeWidth: 2,
                  ),
                ),
              )
            : _avatarBytes != null
            ? Image.memory(_avatarBytes!, fit: BoxFit.cover)
            : Container(
                color: Colors.grey[800],
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
      ),
    );
  }
}

// WIDGET PARA IMAGEN DE MEMBRESÍA SIN RECUADRO
class _MembershipImage extends StatelessWidget {
  final String subscriptionImage;

  const _MembershipImage({required this.subscriptionImage});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              subscriptionImage,
              height: 320,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return _buildMembershipFallback();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipFallback() {
    return const Center(
      child: Icon(Icons.workspace_premium, color: Colors.black, size: 50),
    );
  }
}

// SLIDER DE TORNEOS SIN RECUADRO
class _TournamentActions extends StatelessWidget {
  const _TournamentActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActionButton(
          label: 'TORNEOS MENSUALES',
          icon: Icons.calendar_month,
          color: Colors.deepOrange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TournamentStatsScreen(tipo: 'torneos'),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _ActionButton(
          label: 'RANKING GLOBAL',
          icon: Icons.public,
          color: Colors.deepOrange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TournamentStatsScreen(tipo: 'global'),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 11.2,
                letterSpacing: 1,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            shadows: [
              Shadow(color: Colors.black, blurRadius: 5, offset: Offset(1, 1)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

class _AchievementsWidget extends StatefulWidget {
  final List<dynamic> achievements;

  const _AchievementsWidget({required this.achievements});

  @override
  State<_AchievementsWidget> createState() => __AchievementsWidgetState();
}

class __AchievementsWidgetState extends State<_AchievementsWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  final Map<String, Uint8List> _imageCache = {};
  final Map<String, bool> _loadingStates = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _preloadImages();
    _startAutoScroll();
  }

  void _preloadImages() {
    for (final achievement in widget.achievements) {
      final iconUrl = achievement['icon']?.toString() ?? '';
      if (iconUrl.isNotEmpty && !_imageCache.containsKey(iconUrl)) {
        _loadImage(iconUrl);
      }
    }
  }

  Future<void> _loadImage(String url) async {
    if (_imageCache.containsKey(url)) return;

    setState(() {
      _loadingStates[url] = true;
    });

    try {
      final imageBytes = await ImageService.downloadImage(url);
      if (imageBytes != null && mounted) {
        setState(() {
          _imageCache[url] = imageBytes;
          _loadingStates[url] = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingStates[url] = false;
        });
      }
    }
  }

  void _startAutoScroll() {
    if (widget.achievements.length <= 1) return;

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % widget.achievements.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.achievements.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            child: Center(
              child: Icon(
                Icons.emoji_events,
                color: Colors.orange.withOpacity(0.7),
                size: 80,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "¡Aún no tienes logros!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Participa en torneos para ganarlos",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slider de logros
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.achievements.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final achievement = widget.achievements[index];
                final iconUrl = achievement['icon']?.toString() ?? '';
                final title = achievement['title']?.toString() ?? 'Logro';

                return _buildAchievementCard(
                  iconUrl,
                  title,
                  index == _currentPage,
                );
              },
            ),
          ),
          const SizedBox(height: 15),

          // Indicadores de página
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.achievements.length, (index) {
              return Container(
                width: index == _currentPage ? 12 : 8,
                height: index == _currentPage ? 12 : 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentPage
                      ? Colors.orange
                      : Colors.orange.withOpacity(0.3),
                ),
              );
            }),
          ),

          // Título del logro actual
          const SizedBox(height: 15),
          if (widget.achievements.isNotEmpty &&
              _currentPage < widget.achievements.length)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.achievements[_currentPage]['title']?.toString() ??
                    'Logro',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String iconUrl, String title, bool isActive) {
    final isLoading = _loadingStates[iconUrl] ?? true;
    final imageBytes = _imageCache[iconUrl];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagen del logro
          Container(
            width: 140,
            height: 140,
            alignment: Alignment.center,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                      strokeWidth: 3,
                    ),
                  )
                : imageBytes != null
                ? Image.memory(
                    imageBytes!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.emoji_events,
                        color: Colors.orange.withOpacity(0.7),
                        size: 60,
                      );
                    },
                  )
                : Icon(
                    Icons.emoji_events,
                    color: Colors.orange.withOpacity(0.7),
                    size: 60,
                  ),
          ),

          // Nombre del logro
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
