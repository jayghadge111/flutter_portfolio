import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayesh_flutter/src/widgets/main_title.dart';

import '../models/portfolio_data.dart';

class Work extends ConsumerStatefulWidget {
  final PortfolioData portfolioData;

  const Work({
    super.key,
    required this.portfolioData,
  });

  @override
  _WorkState createState() => _WorkState();
}

class _WorkState extends ConsumerState<Work> {
  late List<String> companies;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize companies from portfolio data
    companies = [];
    if (widget.portfolioData.experience != null &&
        widget.portfolioData.experience!.isNotEmpty) {
      for (var exp in widget.portfolioData.experience!) {
        if (exp.company != null && exp.company!.isNotEmpty) {
          companies.add(exp.company!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (companies.isEmpty) {
      return const SizedBox
          .shrink(); // If no experience data, don't show this section
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MainTitle(number: "02.", text: "Professional experience"),
          const SizedBox(height: 40.0),
          Row(
            children: [
              // Company Tabs
              SizedBox(
                width: 200.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    return CompanyTab(
                      company: companies[index],
                      isSelected: selectedIndex == index,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 32.0),
              // Experience Details
              Expanded(
                child: _buildExperienceDetails(selectedIndex),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceDetails(int index) {
    if (widget.portfolioData.experience != null &&
        widget.portfolioData.experience!.length > index) {
      // Use data from portfolio
      final exp = widget.portfolioData.experience![index];
      return ExperienceCard(
        title: exp.title ?? "",
        company: exp.company ?? "",
        duration: exp.duration ?? "",
        points: exp.responsibilities ?? [],
      );
    }

    // If no experience data for this index, return empty container
    return Container();
  }
}

class CompanyTab extends StatelessWidget {
  final String company;
  final bool isSelected;
  final VoidCallback onTap;

  const CompanyTab({
    super.key,
    required this.company,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isSelected ? const Color(0xff64FFDA) : Colors.transparent,
              width: 2.0,
            ),
          ),
          color: isSelected ? const Color(0xff112240) : Colors.transparent,
        ),
        child: Text(
          company,
          style: TextStyle(
            color:
                isSelected ? const Color(0xff64FFDA) : const Color(0xff8892B0),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

class ExperienceCard extends StatelessWidget {
  final String title;
  final String company;
  final String duration;
  final List<String> points;

  const ExperienceCard({
    super.key,
    required this.title,
    required this.company,
    required this.duration,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xffCCD6F6),
            fontSize: 21.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          company,
          style: const TextStyle(
            color: Color(0xff64FFDA),
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          duration,
          style: const TextStyle(
            color: Color(0xff8892B0),
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 16.0),
        Column(
          children: points.map((point) => _buildBulletPoint(point)).toList(),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "▹",
            style: TextStyle(
              color: Color(0xff64FFDA),
              fontSize: 16.0,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xff8892B0),
                fontSize: 16.0,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
