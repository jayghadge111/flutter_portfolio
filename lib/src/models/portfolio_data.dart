import 'dart:convert';

class PortfolioData {
  String? name;
  String? headline;
  String? shortSummary;
  Contact? contact;
  String? summary;
  Skills? skills;
  List<Experience>? experience;
  List<Projects>? projects;
  List<Education>? education;
  List<String>? domains;
  List<String>? languages;
  String? dob;
  String? maritalStatus;
  List<String>? interests;
  CoreStrengthsAndExpertise? coreStrengthsAndExpertise;

  PortfolioData(
      {this.name,
      this.headline,
      this.shortSummary,
      this.contact,
      this.summary,
      this.skills,
      this.experience,
      this.projects,
      this.education,
      this.domains,
      this.languages,
      this.dob,
      this.maritalStatus,
      this.interests,
      this.coreStrengthsAndExpertise});

  factory PortfolioData.fromRawJson(String str) =>
      PortfolioData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  PortfolioData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    headline = json['headline'];
    shortSummary = json['short_summary'];
    contact =
        json['contact'] != null ? Contact.fromJson(json['contact']) : null;
    summary = json['summary'];
    skills = json['skills'] != null ? Skills.fromJson(json['skills']) : null;
    if (json['experience'] != null) {
      experience = <Experience>[];
      json['experience'].forEach((v) {
        experience!.add(Experience.fromJson(v));
      });
    }
    if (json['projects'] != null) {
      projects = <Projects>[];
      json['projects'].forEach((v) {
        projects!.add(Projects.fromJson(v));
      });
    }
    if (json['education'] != null) {
      education = <Education>[];
      json['education'].forEach((v) {
        education!.add(Education.fromJson(v));
      });
    }
    domains = json['domains'].cast<String>();
    languages = json['languages'].cast<String>();
    dob = json['dob'];
    maritalStatus = json['marital_status'];
    interests = json['interests'].cast<String>();
    coreStrengthsAndExpertise = json['coreStrengthsAndExpertise'] != null
        ? CoreStrengthsAndExpertise.fromJson(json['coreStrengthsAndExpertise'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['headline'] = headline;
    data['short_summary'] = shortSummary;
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    data['summary'] = summary;
    if (skills != null) {
      data['skills'] = skills!.toJson();
    }
    if (experience != null) {
      data['experience'] = experience!.map((v) => v.toJson()).toList();
    }
    if (projects != null) {
      data['projects'] = projects!.map((v) => v.toJson()).toList();
    }
    if (education != null) {
      data['education'] = education!.map((v) => v.toJson()).toList();
    }
    data['domains'] = domains;
    data['languages'] = languages;
    data['dob'] = dob;
    data['marital_status'] = maritalStatus;
    data['interests'] = interests;
    if (coreStrengthsAndExpertise != null) {
      data['coreStrengthsAndExpertise'] = coreStrengthsAndExpertise!.toJson();
    }
    return data;
  }
}

class Contact {
  List<String>? mobile;
  String? email;
  String? linkedin;
  String? nationality;
  String? currentCountry;
  String? currentAddress;
  String? permanentAddress;

  Contact(
      {this.mobile,
      this.email,
      this.linkedin,
      this.nationality,
      this.currentCountry,
      this.currentAddress,
      this.permanentAddress});

  Contact.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'].cast<String>();
    email = json['email'];
    linkedin = json['linkedin'];
    nationality = json['nationality'];
    currentCountry = json['current_country'];
    currentAddress = json['current_address'];
    permanentAddress = json['permanent_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile'] = mobile;
    data['email'] = email;
    data['linkedin'] = linkedin;
    data['nationality'] = nationality;
    data['current_country'] = currentCountry;
    data['current_address'] = currentAddress;
    data['permanent_address'] = permanentAddress;
    return data;
  }
}

class Skills {
  List<String>? mobileDevelopment;
  List<String>? architecture;
  List<String>? stateManagement;
  List<String>? backendIntegration;
  List<String>? security;
  List<String>? database;
  List<String>? tools;
  List<String>? testing;

  Skills(
      {this.mobileDevelopment,
      this.architecture,
      this.stateManagement,
      this.backendIntegration,
      this.security,
      this.database,
      this.tools,
      this.testing});

  Skills.fromJson(Map<String, dynamic> json) {
    mobileDevelopment = json['mobile_development'].cast<String>();
    architecture = json['architecture'].cast<String>();
    stateManagement = json['state_management'].cast<String>();
    backendIntegration = json['backend_integration'].cast<String>();
    security = json['security'].cast<String>();
    database = json['database'].cast<String>();
    tools = json['tools'].cast<String>();
    testing = json['testing'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile_development'] = mobileDevelopment;
    data['architecture'] = architecture;
    data['state_management'] = stateManagement;
    data['backend_integration'] = backendIntegration;
    data['security'] = security;
    data['database'] = database;
    data['tools'] = tools;
    data['testing'] = testing;
    return data;
  }
}

class Experience {
  String? title;
  String? company;
  String? duration;
  List<String>? responsibilities;

  Experience({this.title, this.company, this.duration, this.responsibilities});

  Experience.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    company = json['company'];
    duration = json['duration'];
    responsibilities = json['responsibilities'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['company'] = company;
    data['duration'] = duration;
    data['responsibilities'] = responsibilities;
    return data;
  }
}

class Projects {
  String? name;
  String? description;
  String? platform;
  String? status;
  String? image;
  Links? links;

  Projects(
      {this.name,
      this.description,
      this.platform,
      this.status,
      this.image,
      this.links});

  Projects.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    platform = json['platform'];
    status = json['status'];
    image = json['image'];
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['platform'] = platform;
    data['status'] = status;
    data['image'] = image;
    if (links != null) {
      data['links'] = links!.toJson();
    }
    return data;
  }
}

class Links {
  String? playStore;
  String? appStore;
  String? indusAppStore;
  String? web;

  Links({this.playStore, this.appStore, this.indusAppStore, this.web});

  Links.fromJson(Map<String, dynamic> json) {
    playStore = json['playStore'];
    appStore = json['appStore'];
    indusAppStore = json['indusAppStore'];
    web = json['web'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['playStore'] = playStore;
    data['appStore'] = appStore;
    data['indusAppStore'] = indusAppStore;
    data['web'] = web;
    return data;
  }
}

class Education {
  String? degree;
  String? institute;
  String? year;
  String? score;

  Education({this.degree, this.institute, this.year, this.score});

  Education.fromJson(Map<String, dynamic> json) {
    degree = json['degree'];
    institute = json['institute'];
    year = json['year'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['degree'] = degree;
    data['institute'] = institute;
    data['year'] = year;
    data['score'] = score;
    return data;
  }
}

class CoreStrengthsAndExpertise {
  TechnicalLeadership? technicalLeadership;
  TechnicalLeadership? businessDomainKnowledge;
  TechnicalLeadership? technicalInnovation;
  TechnicalLeadership? projectManagement;

  CoreStrengthsAndExpertise(
      {this.technicalLeadership,
      this.businessDomainKnowledge,
      this.technicalInnovation,
      this.projectManagement});

  CoreStrengthsAndExpertise.fromJson(Map<String, dynamic> json) {
    technicalLeadership = json['technicalLeadership'] != null
        ? TechnicalLeadership.fromJson(json['technicalLeadership'])
        : null;
    businessDomainKnowledge = json['businessDomainKnowledge'] != null
        ? TechnicalLeadership.fromJson(json['businessDomainKnowledge'])
        : null;
    technicalInnovation = json['technicalInnovation'] != null
        ? TechnicalLeadership.fromJson(json['technicalInnovation'])
        : null;
    projectManagement = json['projectManagement'] != null
        ? TechnicalLeadership.fromJson(json['projectManagement'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (technicalLeadership != null) {
      data['technicalLeadership'] = technicalLeadership!.toJson();
    }
    if (businessDomainKnowledge != null) {
      data['businessDomainKnowledge'] = businessDomainKnowledge!.toJson();
    }
    if (technicalInnovation != null) {
      data['technicalInnovation'] = technicalInnovation!.toJson();
    }
    if (projectManagement != null) {
      data['projectManagement'] = projectManagement!.toJson();
    }
    return data;
  }
}

class TechnicalLeadership {
  List<String>? highlights;

  TechnicalLeadership({this.highlights});

  TechnicalLeadership.fromJson(Map<String, dynamic> json) {
    highlights = json['highlights'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['highlights'] = highlights;
    return data;
  }
}
