--
-- File generated with SQLiteStudio v3.2.1 on Sun Aug 22 19:09:18 2021
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: calendar
CREATE TABLE calendar (
    cal_id       INTEGER PRIMARY KEY,
    class        INTEGER,
    week         INTEGER,
    date         TEXT,
    topic        TEXT,
    topic_id     TEXT,
    homework_id  TEXT,
    event_id     TEXT,
    reading_id   TEXT,
    has_class    BOOLEAN,
    save_date_as TEXT
);

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         1,
                         1,
                         1,
                         '2019-08-22',
                         'Introduction',
                         'INTRO',
                         NULL,
                         NULL,
                         NULL,
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         2,
                         2,
                         1,
                         '2019-08-27',
                         'The computer modeling cycle',
                         'MODELING_CYCLE',
                         'HW_SETUP',
                         NULL,
                         'MODELING_CYCLE',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         3,
                         3,
                         2,
                         '2019-08-29',
                         'Introduction to <%NETLOGO%>',
                         'INTRO_NETLOGO',
                         'HW_INTRO_NETLOGO',
                         NULL,
                         'INTRO_NETLOGO',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         4,
                         4,
                         2,
                         '2019-09-03',
                         'Specifying models: The ODD protocol',
                         'ODD_PROTOCOL',
                         'HW_TUTORIALS',
                         NULL,
                         'ODD_PROTOCOL',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         5,
                         5,
                         3,
                         '2019-09-05',
                         'Your first model',
                         'FIRST_MODEL',
                         'HW_EXPERIMENTING',
                         NULL,
                         'FIRST_MODEL',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         6,
                         6,
                         3,
                         '2019-09-10',
                         'Using models for science',
                         'MODELS_FOR_SCIENCE',
                         NULL,
                         NULL,
                         'MODELS_FOR_SCIENCE',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         7,
                         7,
                         4,
                         '2019-09-12',
                         'Testing and validating models',
                         'TESTING_VALIDATING',
                         'HW_MODEL_SCIENCE',
                         NULL,
                         'TESTING_VALIDATING',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         8,
                         8,
                         4,
                         '2019-09-17',
                         'Choosing Research Projects',
                         'CHOOSING_PROJECTS',
                         NULL,
                         NULL,
                         'CHOOSING_PROJECTS',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         9,
                         9,
                         5,
                         '2019-09-19',
                         'Emergence',
                         'EMERGENCE',
                         'HW_ODD',
                         NULL,
                         'EMERGENCE',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         10,
                         10,
                         5,
                         '2019-09-24',
                         'Observation',
                         'OBSERVATION',
                         'HW_TESTING',
                         NULL,
                         'OBSERVATION',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         11,
                         11,
                         6,
                         '2019-09-26',
                         'Sensing',
                         'SENSING',
                         NULL,
                         NULL,
                         'SENSING',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         12,
                         NULL,
                         NULL,
                         '2019-09-27',
                         'Semester project proposal due',
                         'PROJECT_PROPOSAL_DUE',
                         'HW_PROJECT_PROPOSAL',
                         NULL,
                         NULL,
                         0,
                         'DUE_DATE_PROJECT_PROPOSAL'
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         13,
                         12,
                         6,
                         '2019-10-01',
                         'Adaptive Behavior and Objectives',
                         'ADAPTATION',
                         'HW_EXPT_ANALYSIS',
                         NULL,
                         'ADAPTATION',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         14,
                         13,
                         7,
                         '2019-10-03',
                         'Prediction',
                         'PREDICTION',
                         'HW_SENSING',
                         NULL,
                         'PREDICTION',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         15,
                         14,
                         7,
                         '2019-10-08',
                         'Interaction',
                         'INTERACTION',
                         NULL,
                         NULL,
                         'INTERACTION',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         16,
                         15,
                         8,
                         '2019-10-10',
                         'Team Presentations',
                         'TEAM_PRESENTATIONS',
                         'HW_TEAM_PROJECT_PRESENTATION',
                         NULL,
                         'TEAM_PRESENTATIONS',
                         1,
                         'DATE_TEAM_PRESENTATION'
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         17,
                         NULL,
                         NULL,
                         '2019-10-11',
                         'Team Project Report',
                         'TEAM_REPORTS',
                         'HW_TEAM_PROJECT_REPORT',
                         NULL,
                         NULL,
                         0,
                         'DATE_TEAM_REPORT'
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         18,
                         16,
                         8,
                         '2019-10-15',
                         'Research Project ODDs',
                         'PROJECT_ODDS',
                         'HW_PROJECT_ANALYSIS',
                         NULL,
                         'PROJECT_ODDS',
                         1,
                         'DUE_DATE_PROJECT_ANALYSIS'
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         19,
                         17,
                         9,
                         '2019-10-17',
                         'Scheduling',
                         'SCHEDULING',
                         NULL,
                         NULL,
                         'SCHEDULING',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         20,
                         18,
                         9,
                         '2019-10-22',
                         'Stochasticity',
                         'STOCHASTICITY',
                         NULL,
                         NULL,
                         'STOCHASTICITY',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         21,
                         NULL,
                         NULL,
                         '2019-10-23',
                         'Project ODD Due',
                         'PROJECT_ODD_DUE',
                         'HW_PROJECT_ODD',
                         NULL,
                         NULL,
                         0,
                         'DUE_DATE_PROJECT_ODD'
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         22,
                         NULL,
                         NULL,
                         '2019-10-24',
                         'Fall Break',
                         NULL,
                         NULL,
                         'FALL_BREAK',
                         NULL,
                         0,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         23,
                         19,
                         10,
                         '2019-10-29',
                         'Collectives',
                         'COLLECTIVES',
                         NULL,
                         NULL,
                         'COLLECTIVES',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         24,
                         20,
                         10,
                         '2019-10-31',
                         'Patterns',
                         'PATTERNS',
                         NULL,
                         NULL,
                         'PATTERNS',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         25,
                         21,
                         11,
                         '2019-11-05',
                         'Theory Development',
                         'THEORY_DEVELOPMENT',
                         NULL,
                         NULL,
                         'THEORY_DEVELOPMENT',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         26,
                         22,
                         11,
                         '2019-11-07',
                         'Parameterization and Calibration',
                         'PARAMETERIZATION_1',
                         NULL,
                         NULL,
                         'PARAMETERIZATION_1',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         27,
                         NULL,
                         NULL,
                         '2019-11-15',
                         'Draft Model Code Due',
                         'PROJECT_DRAFT_DUE',
                         'HW_PROJECT_DRAFT',
                         NULL,
                         NULL,
                         0,
                         'DUE_DATE_PROJECT_DRAFT'
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         28,
                         23,
                         12,
                         '2019-11-12',
                         'Parameterization and Calibration 2',
                         'PARAMETERIZATION_2',
                         NULL,
                         NULL,
                         'PARAMETERIZATION_2',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         29,
                         24,
                         12,
                         '2019-11-14',
                         'Analyzing ABMs',
                         'ANALYZING_ABMS',
                         NULL,
                         NULL,
                         'ANALYZING_ABMS',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         30,
                         25,
                         13,
                         '2019-11-19',
                         'Sensitivity and Robustness',
                         'SENSITIVITY_ROBUSTNESS',
                         NULL,
                         NULL,
                         'SENSITIVITY_ROBUSTNESS',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         31,
                         26,
                         13,
                         '2019-11-21',
                         'Looking Ahead: ABMs Beyond this Course',
                         'LOOKING_AHEAD',
                         NULL,
                         NULL,
                         'LOOKING_AHEAD',
                         1,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         32,
                         NULL,
                         NULL,
                         '2019-11-26',
                         'Thanksgiving Break',
                         NULL,
                         NULL,
                         'THANKSGIVING_BREAK',
                         NULL,
                         0,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         33,
                         NULL,
                         NULL,
                         '2019-11-28',
                         'Thanksgiving Break',
                         NULL,
                         NULL,
                         'THANKSGIVING_BREAK',
                         NULL,
                         0,
                         NULL
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         34,
                         27,
                         14,
                         '2019-12-03',
                         'Presentations',
                         'PRESENTATIONS_1',
                         'HW_PROJECT_PRESENTATION',
                         NULL,
                         'PRESENTATIONS_1',
                         1,
                         'DATE_PROJECT_PRESENTATION_1'
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         35,
                         28,
                         14,
                         '2019-12-05',
                         'Presentations',
                         'PRESENTATIONS_2',
                         'HW_PROJECT_PRESENTATION',
                         NULL,
                         'PRESENTATIONS_2',
                         1,
                         'DATE_PROJECT_PRESENTATION_2'
                     );

INSERT INTO calendar (
                         cal_id,
                         class,
                         week,
                         date,
                         topic,
                         topic_id,
                         homework_id,
                         event_id,
                         reading_id,
                         has_class,
                         save_date_as
                     )
                     VALUES (
                         36,
                         NULL,
                         NULL,
                         '2019-12-06',
                         'Final project report',
                         'PROJECT_REPORT',
                         'HW_PROJECT_REPORT',
                         NULL,
                         NULL,
                         0,
                         'DATE_PROJECT_REPORT'
                     );


-- Table: events
CREATE TABLE events (
    event_id TEXT PRIMARY KEY
                  UNIQUE
                  NOT NULL,
    event    TEXT
);

INSERT INTO events (
                       event_id,
                       event
                   )
                   VALUES (
                       'FALL_BREAK',
                       'Fall Break'
                   );

INSERT INTO events (
                       event_id,
                       event
                   )
                   VALUES (
                       'THANKSGIVING_BREAK',
                       'Thanksgiving Break'
                   );


-- Table: homework_assignments
CREATE TABLE homework_assignments (
    hw_asg_id      INTEGER PRIMARY KEY
                           UNIQUE
                           NOT NULL,
    hw_group       TEXT    NOT NULL
                           UNIQUE,
    hw_due_date    TEXT,
    hw_title       TEST,
    hw_slug        TEXT,
    hw_is_numbered BOOLEAN,
    hw_type        TEXT,
    med_hw_type    TEXT,
    short_hw_type  TEXT
);

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     1,
                                     'HW_SETUP',
                                     NULL,
                                     'Set up Box and <%NETLOGO%>',
                                     'setup',
                                     1,
                                     'Homework',
                                     'Homework',
                                     'HW'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     2,
                                     'HW_INTRO_NETLOGO',
                                     NULL,
                                     'Introducing <%NETLOGO%>',
                                     'intro_netlogo',
                                     1,
                                     'Homework',
                                     'Homework',
                                     'HW'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     3,
                                     'HW_TUTORIALS',
                                     NULL,
                                     'Becoming familiar with <%NETLOGO%>',
                                     'netlogo_tutorials',
                                     1,
                                     'Homework',
                                     'Homework',
                                     'HW'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     4,
                                     'HW_EXPERIMENTING',
                                     NULL,
                                     'Experimenting with <%NETLOGO%>',
                                     'experimenting_netlogo',
                                     1,
                                     'Homework',
                                     'Homework',
                                     'HW'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     5,
                                     'HW_MODEL_SCIENCE',
                                     NULL,
                                     'Science with models: Butterfly mating',
                                     'butterfly_mating',
                                     1,
                                     'Homework',
                                     'Homework',
                                     'HW'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     6,
                                     'HW_ODD',
                                     NULL,
                                     'Reproducing a model from its ODD',
                                     'model_from_odd',
                                     1,
                                     'Homework',
                                     'Homework',
                                     'HW'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     7,
                                     'HW_PROJECT_PROPOSAL',
                                     NULL,
                                     'Research project proposal',
                                     'project_proposal',
                                     0,
                                     'Semester Project Assignment',
                                     'Assignment',
                                     'Assignment'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     8,
                                     'HW_TESTING',
                                     NULL,
                                     'Testing and debugging models',
                                     'testing',
                                     1,
                                     'Homework',
                                     'Homework',
                                     'HW'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     9,
                                     'HW_EXPT_ANALYSIS',
                                     NULL,
                                     'Analyzing model experiments',
                                     'analyzing_experiments',
                                     1,
                                     'Homework',
                                     'Homework',
                                     'HW'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     10,
                                     'HW_SENSING',
                                     NULL,
                                     'Programming agent sensing',
                                     'sensing',
                                     1,
                                     'Homework',
                                     'Homework',
                                     'HW'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     11,
                                     'HW_PROJECT_ANALYSIS',
                                     NULL,
                                     'Analysis of a published model',
                                     'project_analysis',
                                     0,
                                     'Semester Project Assignment',
                                     'Assignment',
                                     'Assignment'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     12,
                                     'HW_TEAM_PROJECT_PRESENTATION',
                                     NULL,
                                     'Team modeling project presentations',
                                     'team_project_presentation',
                                     0,
                                     'Team Project Assignment',
                                     'Presentation',
                                     'Team Project'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     13,
                                     'HW_TEAM_PROJECT_REPORT',
                                     NULL,
                                     'Team modeling project reports',
                                     'team_project_report',
                                     0,
                                     'Team Project Assignment',
                                     'Report',
                                     'Team Project'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     14,
                                     'HW_PROJECT_ODD',
                                     NULL,
                                     'Research project ODD',
                                     'project_odd',
                                     0,
                                     'Semester Project Assignment',
                                     'Assignment',
                                     'Assignment'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     15,
                                     'HW_PROJECT_DRAFT',
                                     NULL,
                                     'Draft model code for research project',
                                     'project_draft_code',
                                     0,
                                     'Semester Project Assignment',
                                     'Assignment',
                                     'Assignment'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     16,
                                     'HW_PROJECT_PRESENTATION',
                                     NULL,
                                     'Research project presentations',
                                     'project_presentation',
                                     0,
                                     'Semester Project Assignment',
                                     'Assignment',
                                     'Presentation'
                                 );

INSERT INTO homework_assignments (
                                     hw_asg_id,
                                     hw_group,
                                     hw_due_date,
                                     hw_title,
                                     hw_slug,
                                     hw_is_numbered,
                                     hw_type,
                                     med_hw_type,
                                     short_hw_type
                                 )
                                 VALUES (
                                     17,
                                     'HW_PROJECT_REPORT',
                                     NULL,
                                     'Research project report',
                                     'project_report',
                                     0,
                                     'Semester Project Assignment',
                                     'Assignment',
                                     'Assignment'
                                 );


-- Table: homework_groups
CREATE TABLE homework_groups (
    homework_order INTEGER UNIQUE,
    homework_id    TEXT    PRIMARY KEY
                           NOT NULL
                           UNIQUE,
    hw_group       INTEGER NOT NULL
                           UNIQUE
);

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                9,
                                'HW_EXPT_ANALYSIS',
                                'HW_EXPT_ANALYSIS'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                10,
                                'HW_SENSING',
                                'HW_SENSING'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                7,
                                'HW_PROJECT_PROPOSAL',
                                'HW_PROJECT_PROPOSAL'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                12,
                                'HW_TEAM_PROJECT_PRESENTATION',
                                'HW_TEAM_PROJECT_PRESENTATION'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                14,
                                'HW_PROJECT_ODD',
                                'HW_PROJECT_ODD'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                15,
                                'HW_PROJECT_DRAFT',
                                'HW_PROJECT_DRAFT'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                16,
                                'HW_PROJECT_PRESENTATION',
                                'HW_PROJECT_PRESENTATION'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                1,
                                'HW_SETUP',
                                'HW_SETUP'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                2,
                                'HW_INTRO_NETLOGO',
                                'HW_INTRO_NETLOGO'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                3,
                                'HW_TUTORIALS',
                                'HW_TUTORIALS'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                4,
                                'HW_EXPERIMENTING',
                                'HW_EXPERIMENTING'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                5,
                                'HW_MODEL_SCIENCE',
                                'HW_MODEL_SCIENCE'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                6,
                                'HW_ODD',
                                'HW_ODD'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                8,
                                'HW_TESTING',
                                'HW_TESTING'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                11,
                                'HW_PROJECT_ANALYSIS',
                                'HW_PROJECT_ANALYSIS'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                17,
                                'HW_PROJECT_REPORT',
                                'HW_PROJECT_REPORT'
                            );

INSERT INTO homework_groups (
                                homework_order,
                                homework_id,
                                hw_group
                            )
                            VALUES (
                                13,
                                'HW_TEAM_PROJECT_REPORT',
                                'HW_TEAM_PROJECT_REPORT'
                            );


-- Table: homework_items
CREATE TABLE homework_items (
    hw_item_id         INTEGER PRIMARY KEY,
    hw_group           TEXT,
    short_homework     TEXT,
    homework           TEXT,
    homework_notes     TEXT,
    undergraduate_only BOOLEAN,
    graduate_only      BOOLEAN,
    hw_break_before    BOOLEAN,
    hw_prologue        BOOLEAN,
    hw_epilogue        BOOLEAN
);

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               100,
                               'HW_SETUP',
                               NULL,
                               '**There is nothing for you to turn in**, but do the following two tasks to prepare for next week:',
                               NULL,
                               0,
                               0,
                               0,
                               1,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               101,
                               'HW_SETUP',
                               'Install <%NETLOGO%>',
                               'Download <%NETLOGO%> version <%NETLOGO_VERSION%> from <https://ccl.northwestern.edu/netlogo/> and install it on your computer.',
                               NULL,
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               102,
                               'HW_SETUP',
                               'Set up Box account',
                               'Set up your Box account. Make a Box folder for your homework for this course (call it `Lastname_EES_<%UGRAD_COURSE_NUM%>` (undergraduates) or `Lastname_EES_<%UGRAD_COURSE_NUM%>` (graduate students), substituting your own last name), and share it with me, giving me "Editor" role.',
                               NULL,
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               201,
                               'HW_INTRO_NETLOGO',
                               'Mushroom hunt',
                               'As you read along with Section 2.3, follow along on your computer and build the _Mushroom Hunt_ model by typing in the code shown in the textbook. The whole program is shown on pages 27--29. 
**Save your model as `mushroom_hunt.nlogo`**.

This exercise may seem very simple, but it is the first step toward learning how to program <%NETLOGO%> and it will be an important first step toward writing your own models.

After you are done typing in your model, try running it.

**When you are done, make a subfolder called `HW_2` in your Box folder for this class, and upload your model.**',
                               'I recommend getting together with a classmate and working together on this assignment. Since the assignment consists of typing code in and running it, do not worry about your work being identical to your partner''s. However, I strongly recommend that you type everything in yourself because you will not learn if you just copy someone else''s code or download the code from a source on the web.

If you run into trouble and cannot make your model work, do not worry. Ask a classmate for help, or email me (and attach your `.nlogo` model file), or simply come to class on Tuesday with questions about the problems you had getting your model to work. Since your model file will be on Box, we will be able to discuss the problems in class.',
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               300,
                               'HW_TUTORIALS',
                               NULL,
                               'This homework consists of reading and working through tutorials, so there is nothing to turn in.',
                               NULL,
                               0,
                               0,
                               0,
                               1,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               301,
                               'HW_TUTORIALS',
                               'Ex. 2.1--2.2',
                               'Everyone should do exercises 1--2 in Chapter 2 of <%ALT_SHORT_RAILSBACK%>. This consists of reading and working through tutorials, so there is nothing to turn in.',
                               NULL,
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               400,
                               'HW_EXPERIMENTING',
                               NULL,
                               'Make a folder called "HW_4" in your Box folder and upload your work when you''re done (Word or text files for the descriptions and ODD document, and `.nlogo` files for your <%NETLOGO%> models).',
                               NULL,
                               0,
                               0,
                               0,
                               1,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               401,
                               'HW_EXPERIMENTING',
                               'Ex. 2.3--2.4',
                               '<%ALT_SHORT_RAILSBACK%>, Chapter 2, exercises Exercises 3--4.

For exercise 4 in chapter 2, you will make seven sequential modifications of the basic mushroom hunt model. Each step modifies the previous one, so the last model will have all the modifications from the bulleted list in Ex. 2.4. Save each model with a new name, such as `ex_2_4a.nlogo`, `ex_2_4b.nlogo`, \dots, `ex_2_4g.nlogo`',
                               NULL,
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               402,
                               'HW_EXPERIMENTING',
                               'Ex. 3.3',
                               '<%ALT_SHORT_RAILSBACK%>, Chapter 3 exercise 3. 

Write your answers in any convenient text format (a simple text file, a Word document, a `.pdf` file, or whatever suits you). Call the file `ex_3_3.docx` (or `ex_3_3.pdf`, etc.).',
                               'My advice for Chapter 3, Exercise 3 is don''t be too ambitious with your model, but keep it very
simple. Don''t worry about getting everything right. If there are things you don''t feel sure about or
don''t know how to express, you should just write a parenthetical note in your ODD document commenting
on your difficulty. Come to class prepared to talk about how this exercise went and where
you felt confused about trying to specify your model.',
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               499,
                               'HW_EXPERIMENTING',
                               NULL,
                               NULL,
                               'As always, I recommend working with another classmate or in a group, comparing your different ways of approaching the exercises, and discussing any difficulties together. ',
                               0,
                               0,
                               0,
                               0,
                               1
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               501,
                               'HW_MODEL_SCIENCE',
                               'Ex. 4.2, 4.4',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 4, Ex. 4.2, 4.4

For exercise 4.4, **instead of the way the exercise is described in the book, do the following:**

* Try adding "noise" to the landscape by adding a random number to the patch elevation.
  1. Add a switch to the interface and call it "noise"
  2. In the `ask patches` statement in `to setup`, change the elevation to this:
     ```
     ask patches
     [
       set elevation 200 + (100 * (sin (pxcor * 3.8) + sin (pycor * 3.8)))
       if noise [ set elevation elevation + random-float 20.0 - 10.0 ]
       set pcolor scale-color green elevation 0 400
     ]
     ```
  3. In the `crt` statementin `to setup` (where you create the turtles), instead of
     `setxy random-pxcor random-pycor` write `setxy 71 71` to start the turtles in the 
     middle of the hills.
  Write up answers to the following questions and turn them in to the box folder:

  1. Compare the turtle behavior with `noise` off to `noise` on for several values of `q`.
     How does the noise affect the movement?
  2. Does this give you any insight into why the paths in the original (noise-free) model look
     artificial and unlike what you might expect butterflies to do in the real world?',
                               NULL,
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               502,
                               'HW_MODEL_SCIENCE',
                               'Ex. 5.1, 5.2, 5.4, and 5.7',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 5, Ex. 5.1, 5.2, 5.4, and 5.7.',
                               'For exercise 5.1, you should have three versions of the model. Each version adds new changes on top of the previous version:

* one version of the model that incorporates all the changes (listed with triangular bullets in the book) in section 5.2 (pp. 64--68), 
* one version that starts with the previous version from 5.2 and also incorporates the additional changes in section 5.4 (p. 70),
* one version that starts with the previous version from 5.4 and also incorporates the additional changes in section 5.5 (p. 73)

For exercise 5.2, look in the NetLogo dictionary for a command that does what you want. The point of this exercise is to start getting 
you used to looking for new <%NETLOGO%> commands when you want to do something you haven''t yet learned about.

Exercise 5.7 asks you to answer a question about the modified model. Be sure to turn in an answer to the question (you can do this in 
a separate text document or you can edit the "Info" tab to put your answer at the top of the info page by pasting the following in and
editing to add your answer.

```
# Answer to 5.7

answer goes here...

```

If you prefer to hand-write your answer, that''s fine. Just take a picture of it with your phone and upload the picture to the Box folder and give it a 
meaningful name like "`Ex_5_7_answer.jpg`"',
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               503,
                               'HW_MODEL_SCIENCE',
                               'Ex. 5.5 and 5.8',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 5, exercises 5.5 and 5.8',
                               'For exercises 5.5 and 5.8, you need to answer questions about your models. Do this in a file that you upload to Box, or write your answers on paper and take a picture and upload it, or edit the "Info" page of your model and put the answer there.',
                               0,
                               1,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               601,
                               'HW_ODD',
                               'Ex. 5.11',
                               'Graduate students should do <%ALT_SHORT_RAILSBACK%>, Ex. 5.11',
                               'You can download the journal article for this exercise, [R. Jovani & V. Grimm. (2008) "Breeding synchrony in colonial birds: From local stress to global harmony", _Proc. Royal Soc. London B_ **275**, 1567--63](/files/models/chapter_05/Jovani_Grimm_2008_Breeding.pdf) from the class web site,
<<%CLASS_URL%>files/models/chapter_05/Jovani_Grimm_2008_Breeding.pdf>.

You don''t have to reproduce all of the figures in the paper. Focus on reproducing the information in Figure 2 (make a figure of colony synchrony versus NR and some other figures showing histograms of breeding dates for NR = 0.00, 0.08, 0.20, and 1.00 and comparing them to the histograms in Fig. 2. 

You may also (optionally) try to reproduce Fig. 1 and Fig. 4. 

Fig. 3 is very hard to reproduce because you would need to write a reporter to calculate the size of the colonies and that is quite difficult with what you know at this point about <%NETLOGO%> programming, so I don''t recommend this.

* The paper by Jovani and Grimm forgot to specify the parameter `SD.` It should have the value 10.0.',
                               0,
                               1,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               701,
                               'HW_PROJECT_PROPOSAL',
                               'One-to-two page research project proposal',
                               'Turn in a one-to-two page (double-spaced) proposal for your semester research project.',
                               'This proposal should describe the topic you want to work on, 
identify a published open-source model you want to work with,
and and describe how you think you might want to extend it.

You should consult the textbook, the Model Library in <%NETLOGO%>, 
and the list of reading and computational tools and
resources I distributed on the first day of class (it''s also posted on the
course web site).

If you really want to write your own model instead of working with a
published one, that is also acceptable, but be aware that it may be a lot
more work. I recommend that you do this only if you have previous experience
in programming.

See the semester project assignment for details.',
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               801,
                               'HW_TESTING',
                               'Ex. 6.2, 6.3',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 6, Ex. 6.2, 6.3',
                               'A hint for exercise 6.3:  Patches have integer coordinates (representing the center of the patch). How does the turtle determine the angle to face during `setup`? How does it determine the angle to face in `go-back`? Can you think of a different way to record the path so the `go-back` exactly retraces the path it took during `setup`? If you knew the direction the turtle was heading at each step during `setup`, could you use this heading information to exactly retrace the path?',
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               802,
                               'HW_TESTING',
                               'Ex. 6.4, 6.5, 6.7',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 6, Ex. 6.4, 6.5, 6.7',
                               NULL,
                               0,
                               1,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               901,
                               'HW_EXPT_ANALYSIS',
                               'Ex. 8.1, 8.2',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 8, Ex. 8.1, 8.2',
                               NULL,
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               902,
                               'HW_EXPT_ANALYSIS',
                               'Ex. 8.3, 8.4',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 8, Ex. 8.3, 8.4',
                               NULL,
                               0,
                               1,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               903,
                               'HW_EXPT_ANALYSIS',
                               'Ex. 9.1, 9.3, 9.4',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 9, Ex. 9.1, 9.3, 9.4',
                               NULL,
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               904,
                               'HW_EXPT_ANALYSIS',
                               'Ex. 9.6',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 9, Ex. 9.6',
                               NULL,
                               0,
                               1,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               1000,
                               'HW_SENSING',
                               NULL,
                               NULL,
                               'This homework has been cancelled. You do not have to do it.',
                               0,
                               0,
                               0,
                               1,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               1001,
                               'HW_SENSING',
                               'Ex. 10.1, 10.2',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 10, Ex. 10.1, 10.2',
                               NULL,
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               1002,
                               'HW_SENSING',
                               'Ex. 11.1',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 11, Ex. 11.1',
                               NULL,
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               1003,
                               'HW_SENSING',
                               'Ex. 11.3',
                               '<%ALT_SHORT_RAILSBACK%>, Ch. 11, Ex. 11.3',
                               NULL,
                               0,
                               1,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               1100,
                               'HW_PROJECT_ANALYSIS',
                               'Analysis of the model you chose for your semester research project',
                               'Study the code and ODD of the model you chose for your semester research project, play with the model and run some BehaviorSpace experiments to examine its
output. 

Turn in a 3--5 page (double-spaced) write-up about the model. ',
                               'See the project assignment sheet for details about this assignment.',
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               1200,
                               'HW_TEAM_PROJECT_PRESENTATION',
                               'Team project presentations in class',
                               'Teams will give a presentation on their projects.',
                               'See the team project assignment sheet for details on what I expect for the presentation.',
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               1300,
                               'HW_TEAM_PROJECT_REPORT',
                               'Team project report',
                               'Turn in written report for team project on your Box folder.',
                               'See the team project assignment sheet for details.',
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               1400,
                               'HW_PROJECT_ODD',
                               'ODD for semester research project',
                               'Turn in an ODD for extending your chosen model to ask new questions.',
                               'See the semester research project assignment sheet for details.',
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               1500,
                               'HW_PROJECT_DRAFT',
                               'Draft model code for research project',
                               'Turn in a draft `.nlogo` file with your modified model. The ODD for your modified model should be included in the "Info" section of the model.

You should _also_ turn in a document that describes what you are satisfied with about your draft model and what problems you are struggling with.
',
                               'The model code you turn in should run, but it does not need to be perfect. 
   
The point of this deadline is so that you can check in with me about how
things are going so I can give you feedback and suggestions.

See the project assignment sheet for details.',
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               1600,
                               'HW_PROJECT_PRESENTATION',
                               'Presentation of research project',
                               'You will make a ten-minute presentation in class about your model (seven minutes of talking and three minutes for questions).',
                               'There will not be time to go into all the details in your presentation, so focus on:
* the big question you were addressing,
* a short description of the approach you took to answer it using an agent-based model,
* what you learned from running the model.

See the project assignment sheet for details.',
                               0,
                               0,
                               0,
                               0,
                               0
                           );

INSERT INTO homework_items (
                               hw_item_id,
                               hw_group,
                               short_homework,
                               homework,
                               homework_notes,
                               undergraduate_only,
                               graduate_only,
                               hw_break_before,
                               hw_prologue,
                               hw_epilogue
                           )
                           VALUES (
                               1700,
                               'HW_PROJECT_REPORT',
                               'Final written report for research project',
                               'Turn in a written report about your research project. Your report should follow the model of a research report for _Science_ magazine:
',
                               'See the project assignment sheet for details.',
                               0,
                               0,
                               0,
                               0,
                               0
                           );


-- Table: homework_solutions
CREATE TABLE homework_solutions (
    hw_sol_id       INTEGER PRIMARY KEY
                            UNIQUE
                            NOT NULL
                            DEFAULT (0),
    hw_group        TEXT,
    hw_sol_pub_date TEXT,
    hw_sol_title    TEXT,
    hw_sol_filename TEXT,
    hw_sol_pdf_url  TEXT,
    hw_sol_markdown TEXT
);


-- Table: homework_topics
CREATE TABLE homework_topics (
    homework_id    TEXT PRIMARY KEY
                        UNIQUE,
    homework_topic TEXT
);

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_SETUP',
                                'Set up Box and <%NETLOGO%>'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_INTRO_NETLOGO',
                                'Introducing <%NETLOGO%>'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_TUTORIALS',
                                'Becoming familiar with <%NETLOGO%>'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_EXPERIMENTING',
                                'Experimenting with <%NETLOGO%>'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_MODEL_SCIENCE',
                                'Science with models: Butterfly mating'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_ODD',
                                'Reproducing a model from its ODD'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_PROJECT_PROPOSAL',
                                'Research project proposal'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_TESTING',
                                'Testing and debugging'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_EXPT_ANALYSIS',
                                'Analyzing model experiments'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_SENSING',
                                'Programming agent sensing'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_PROJECT_ANALYSIS',
                                'Research project model analysis'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_TEAM_PROJECT_PRESENTATION',
                                'Team modeling project presentations'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_PROJECT_ODD',
                                'Research project ODD'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_PROJECT_DRAFT',
                                'Draft model code for research project'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_PROJECT_PRESENTATION',
                                'Research project presentation'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_PROJECT_REPORT',
                                'Research project report'
                            );

INSERT INTO homework_topics (
                                homework_id,
                                homework_topic
                            )
                            VALUES (
                                'HW_TEAM_PROJECT_REPORT',
                                'Team modeling project report'
                            );


-- Table: notices
CREATE TABLE notices (
    notice_id INTEGER NOT NULL
                      UNIQUE,
    topic_id  TEXT    NOT NULL
                      UNIQUE,
    topic     TEXT,
    notice    TEXT,
    PRIMARY KEY (
        topic_id
    )
);


-- Table: reading_assignments
CREATE TABLE reading_assignments (
    reading_id TEXT PRIMARY KEY
                    UNIQUE
                    NOT NULL,
    rd_group   TEXT
);

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'MODELING_CYCLE',
                                    'MODELING_CYCLE'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'INTRO_NETLOGO',
                                    'INTRO_NETLOGO'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'ODD_PROTOCOL',
                                    'ODD_PROTOCOL'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'FIRST_MODEL',
                                    'FIRST_MODEL'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'MODELS_FOR_SCIENCE',
                                    'MODELS_FOR_SCIENCE'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'TESTING_VALIDATING',
                                    'TESTING_VALIDATING'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'CHOOSING_PROJECTS',
                                    'CHOOSING_PROJECTS'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'EMERGENCE',
                                    'EMERGENCE'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'OBSERVATION',
                                    'OBSERVATION'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'SENSING',
                                    'SENSING'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'ADAPTATION',
                                    'ADAPTATION'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'PREDICTION',
                                    'PREDICTION'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'INTERACTION',
                                    'INTERACTION'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'TEAM_PRESENTATIONS',
                                    'TEAM_PRESENTATIONS'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'PROJECT_ODDS',
                                    'PROJECT_ODDS'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'SCHEDULING',
                                    'SCHEDULING'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'STOCHASTICITY',
                                    'STOCHASTICITY'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'COLLECTIVES',
                                    'COLLECTIVES'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'PATTERNS',
                                    'PATTERNS'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'THEORY_DEVELOPMENT',
                                    'THEORY_DEVELOPMENT'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'PARAMETERIZATION_1',
                                    'PARAMETERIZATION_1'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'PARAMETERIZATION_2',
                                    'PARAMETERIZATION_2'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'ANALYZING_ABMS',
                                    'ANALYZING_ABMS'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'SENSITIVITY_ROBUSTNESS',
                                    'SENSITIVITY_ROBUSTNESS'
                                );

INSERT INTO reading_assignments (
                                    reading_id,
                                    rd_group
                                )
                                VALUES (
                                    'LOOKING_AHEAD',
                                    'LOOKING_AHEAD'
                                );


-- Table: reading_items
CREATE TABLE reading_items (
    rd_item_id         INTEGER,
    rd_group           TEXT,
    source_id          TEXT,
    chapter            TEXT,
    pages              TEXT,
    item_extra         TEXT,
    reading_notes      TEXT,
    undergraduate_only BOOLEAN,
    graduate_only      BOOLEAN,
    optional           BOOLEAN,
    rd_prologue        BOOLEAN,
    rd_epilogue        BOOLEAN,
    rd_break_before    BOOLEAN
);

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              201,
                              'MODELING_CYCLE',
                              'RAILSBACK_GRIMM',
                              'Ch. 1',
                              NULL,
                              NULL,
                              'This reading sets the stage for answering the questions:

1. What is computational modeling and why is it useful in social and natural science research?
1. What are agent based models? How are they different from other kinds of models? What makes them useful for scientific research?

The reading introduces the idea of a **modeling cycle**. You should understand the different steps in the modeling cycle. You should also think about why Railsback and Grimm describe modeling as a cycle, as opposed to a linear process with a start and stop.  

As to what makes agent-based modeling special, Steven Railsback and Volker Grimm are ecologists and _<%MED_RAILSBACK%>_ emphasizes aspects of agent-based modeling that are well suited for studying ecological systems. Others, such as social scientists, emphasize the aspects of agent-based modeling that are well suited for problems in social science. And still others, such as computer scientists, emphasize aspects of automated and autonomous things (ranging from packets of data on a network to swarms of robots or flying drones that need to coordinate their activities and avoid collisions). What all of these approaches have in common are their use of individuals or **agents** (what is an agent?), which inhabit some kind of space or **environment** (this could be physical space or an abstract space, such as a computer network). Agents **interact** with each other and with the environment, and they make **decisions** according to rules. 


',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              301,
                              'INTRO_NETLOGO',
                              'RAILSBACK_GRIMM',
                              'Ch. 2',
                              NULL,
                              NULL,
                              'Familiarize yourself with <%NETLOGO%>. I recommend that you read through the chapter with <%NETLOGO%> open on your computer. Feel free to play around with <%NETLOGO%> and try things out. The homework consists of following the step-by-step creation of a model in section 2.3.',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              401,
                              'ODD_PROTOCOL',
                              'RAILSBACK_GRIMM',
                              'Ch. 3',
                              NULL,
                              NULL,
                              'Read carefully through the different design principles. Some of them have meanings that are a bit different from what you might infer from colloquial use.

For instance:
* **Adaptation** does not mean a persistent change in a turtle''s behavior similar to the biological/Darwinian sense of adaptation in species. Rather, it means the way an agent changes its behavior in response to its _immediate_ conditions. Thus, adaptation in the ODD sense might include behaviors such as eating when you are hungry (_eating_ is an **adaptation** to _hunger_), putting on warmer clothing when it''s cold out (bundling up is an adaptation to cold), and running away from a predator.
* The kind of persistent changes that arise over time from experience fall under the ODD design concept of **learning**: If there is more food near a river than on hills, turtles may **learn** to go to rivers when they are hungry. 

You can download several useful documents related to the ODD protocol from the class web site:

* The journal article, [V. Grimm _et al._ (2010). "The ODD protocol: A review and first update" _Ecological Modeling_ **221**, 2760--68.](/files/odd/Grimm_2010_ODD_update.pdf). <<%CLASS_URL%>files/odd/Grimm_2010_ODD_update.pdf>
* A Word document that provides [a template for writing ODDs](/files/odd/Grimm_2010_odd_template.docx): <<%CLASS_URL%>files/odd/Grimm_2010_odd_template.docx>
* Lists of scientific publications using agent-based and individual-based models that either do or don''t use the ODD protocol (this appeared as [Appendix 1](/files/odd/Grimm_2010_appendix_1.pdf) of the Grimm _et al._ paper):
    * <<%CLASS_URL%>files/odd/Grimm_2010_appendix_1.pdf>, 
    * <<%CLASS_URL%>files/odd/ch3_ex1_pubs_with_no_ODD.pdf>, 
    * <<%CLASS_URL%>files/odd/ch3_ex2_pubs_with_ODD.pdf>.
',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              501,
                              'FIRST_MODEL',
                              'RAILSBACK_GRIMM',
                              'Ch. 4',
                              NULL,
                              NULL,
                              'For the reading, read Chapter 4 in _<%MED_RAILSBACK%>_ first and focus mostly on this chapter. 

It is worth noting that the Sugarscape model you read about for Aug. 27 is very similar to the hilltopping model. Sugarscape was part of a very influential research project in the 1990s, in which Joshua Epstein and Robert Axtell showed that a very simple model could reproduce complex biological and economic phenomena that are observed in real societies and ecosystems. You may find it interesting at this point to look back at the "Artificial Societies" article and to play with the Sugarscape model in <%NETLOGO%>.

You can download an [ODD for the butterfly model](/files/models/chapter_04/ButterflyModelODD.txt), which is suitable to paste into the "Info" tab in <%NETLOGO%>, from the class web site: <<%CLASS_URL%>files/models/chapter_04/ButterflyModelODD.txt>
',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              601,
                              'MODELS_FOR_SCIENCE',
                              'RAILSBACK_GRIMM',
                              'Ch. 5',
                              NULL,
                              NULL,
                              'This reading sets the stage for answering the big question, "How can we use agent-based models to do science?"
There are several aspects to this question, which this chapter will introduce:

1. How can we produce quantitative output from our models?
1. How can your models read and write data to and from files? (This is important for connecting your model to other parts of your project)
1. How should we test our models to make sure they do what we think they do? (More on this in Chapter 6)
1. Making your research reproducible by using version control and documentation.

A number of you may like to use Excel or statistical analysis tools, such as `R`, `SPSS`, or `Stata`. The material in this chapter about
importing and exporting data using text or `.csv` files will be very useful for this. 
By default, <%NETLOGO%> only allows you to read in data in simple text files. However, if comes with some extensions that you can use to read in 
data from other common file formats, including `.csv` and ArcGIS shapefiles and raster (grid) files.

If you want to read in data from csv files, you may want to 
look at the documentation for the \texttt{csv} extension to <%NETLOGO%>. To use it, you just put the line `includes [csv]` as the first line of your
model, and then  use functions from the extension, such as `let data csv:from-file "myfile.csv"`.

To read in date from ArcGIS files, look at the documentation for the `GIS` extension. You would put the line `extensions [ gis ]` as the
first line of your model, and then use functions, such as `gis:load-dataset`, which can load vector shape files (`.shp`) 
and raster grid files (`.grd` or `.asc`). The GIS extension offers a lot of functions for working with vector and raster GIS data.
If you''re interested in using GIS data in your models, take a look at the GIS examples in the <%NETLOGO%> model library.

<%LATEX_SLOPPY%>
You can download the [data file](/files/models/chapter_05/ElevationData.txt) with the elevations for the realistic butterfly model from 
<<%CLASS_URL%>files/models/chapter_05/ElevationData.txt>
<%LATEX_FUSSY%>',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              701,
                              'TESTING_VALIDATING',
                              'RAILSBACK_GRIMM',
                              'Ch. 6',
                              NULL,
                              NULL,
                              'No one writes perfect programs. Errors in programs controlling medical equipment 
have killed people. Errors in computer models and data analysis code have not had 
such dire results, but have wasted lots of time for researchers and have caused 
public policy to proceed on incorrect assumptions. In many cases, these errors 
were uncovered only after a great deal of frustration because the original 
researchers would not share their computer codes with others who were suspicious 
of their results.

You can never be certain that your model is correct, but the more aggressively 
you check for errors the more confident you can be that it does not have major problems.

Two very important things you can do to ensure that your research does not suffer 
a similar fate are:

1. Test your code. Assume your program has errors in it and make the search for 
those errors a priority in your programming process.
    Some things you can do in this regard are:
      * Write your code with tests that will help you find errors.
      * Work with a partner: after one of you writes code, the other should read 
        it and check for errors.
      * Break your program up into small chunks. It is easier to test and find 
        bugs if you are looking at a short block of code than if you are looking 
        at hundreds of lines of code.
      * Independently reimplement submodels and check whether they agree with the 
        submodel you are using.
1. Publish your code. If you trust your results and believe they are important 
   enough to publish in a book or journal, then you should make your code available 
   (there are many free sites, such as [`github.com`](https://github.com) and 
   [`openabm.org`](https://openabm.org) where people can 
   publish their models and other computer code). 
    
      The more that other researchers can read your code, the greater the probability 
      that they will find any errors, and if you make it easy for others to use your 
      code, it will help science because other people can build on your work, and it 
      will help your reputation because when other people use your model or other 
      code they are likely to cite the publication in which you first announced 
      it, so your work will get attention.
    
      Many scholarly journals demand that you make your code available as a 
      condition for publishing your paper, and federal funding agencies are 
      increasingly requiring that any research funded by their grants must make 
      its code and data available to other researchers and the public.

**The Cultural Dissemination Model**

The 
[paper describing the culture dissemination model](/files/models/chapter_06/axelrod_culture_dissemination_1997.pdf)
and a 
[<%NETLOGO%> model](files/models/chapter_06/CultureDissemination_Untested.nlogo) 
that implements the ODD, but with many errors, can be downloaded from the class web site: 

* <<%CLASS_URL%>files/models/chapter_06/axelrod_culture_dissemination_1997.pdf>, 
* and <<%CLASS_URL%>files/models/chapter_06/CultureDissemination_Untested.nlogo>.
',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              801,
                              'CHOOSING_PROJECTS',
                              'RAILSBACK_GRIMM',
                              'Ch. 7',
                              NULL,
                              NULL,
                              'There is not very much reading for today. Read Chapter 7 of _<%MED_RAILSBACK%>_ carefully (it''s very short) The point of this chapter is to help you get ideas for your term research project.

Before class, I want you to read through the research project assignment and think about what you might want to do for a research project. We will spend class talking about possible research projects.
',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              901,
                              'EMERGENCE',
                              'RAILSBACK_GRIMM',
                              'Ch. 8',
                              NULL,
                              NULL,
                              'This is a major chapter. Emergence is one of the most important concepts in agent-based modeling, so pay close attention to the discussion in this chapter and think about how you can measure and assess emergence.

This chapter also introduces a very important tool for doing experiments in <%NETLOGO%>: **BehaviorSpace**. BehaviorSpace lets you repeatedly run a <%NETLOGO%> model while varying the settings of any of the controls on your user interface. Where there is randomness (stochasticity) in the model, you can perform many runs at each set of control settings. This will let us perform **sensitivity analysis** to determine whether a certain emergent phenomenon we are investigating happens only for values of the parameters within a narrow range, or whether it happens over a wide range of the parameters. It will let us determine which parameters are most important for the phenomenon.

For homework and your modeling projects you will use BehaviorSpace extensively. BehaviorSpace outputs large amounts of data to `.csv` files, which you can read into Excel, R, SPSS, or another tool where you can do statistical analysis and generate plots such as the ones in figures 8.3, 8.5, and 8.6. 

The format in which BehaviorSpace saves its data is very annoying to deal with in many tools. Indeed, it''s almost impossible to do anything useful with it in Excel. Because of this, I have written a tool called `analyzeBehaviorspace` that can read the output of a BehaviorSpace run and allow you to interactively graph it and re-organize the data to make it more useful. 

<%LATEX_SLOPPY%>
You can either use this tool online in a web browser at <https://analyze-behaviorspace.jgilligan.org> or install it on your own computer. For details, see the description of <%LATEX_BREAK%>
`analyzeBehaviorspace` on the "Reading Resources and Computing Tools for Research" handout.
<%LATEX_FUSSY%>

As you read the chapter, be sure to try out the experiments with the birth-and-death model and the flocking model. Try reading the output of the behaviorspace runs into analyzeBehaviorspace (the web version or a local version installed on your computer), or your favorite statistical analysis software and try to generate plots similar to figures 8.3, 8.5, and 8.6.

If you have time, try to play around with BehaviorSpace using those models (varying different parameters) or other models from the <%NETLOGO%> library to explore the ways that changing parameters affects the models'' behavior.
',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              1001,
                              'OBSERVATION',
                              'RAILSBACK_GRIMM',
                              'Ch. 9',
                              NULL,
                              NULL,
                              'In this chapter, we examine how to detect and record the properties of a model 
that we want to study. 

The article, D. Kornhauser, [U. Wilensky, and W. Rand. (2009). "Design guidelines 
for agent-based model visualization," _Journal of Artificial Societies and Social 
Simulation_ **12**, 1](http://jasss.soc.surrey.ac.uk/12/2/1.html) 
is available online at <http://jasss.soc.surrey.ac.uk/12/2/1.html>.

I have posted a [refresher guide](/files/models/chapter_09/ch9_ex8_netlogo_exercises.pdf) 
for <%NETLOGO%> programming on the class web site at <<%CLASS_URL%>files/models/chapter_09/ch9_ex8_netlogo_exercises.pdf>
',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              1101,
                              'SENSING',
                              'RAILSBACK_GRIMM',
                              'Ch. 10',
                              NULL,
                              NULL,
                              'Important programming concepts in this chapter include:

Links:
  ~ Agents interact with their physical environment (patches around them) and with other agents nearby, but they can also interact in social networks, which can be represented by links.
    
Variable scope: 
  ~ Understand the differences between global variables, local variables, patch variables, agent variables, and link variables. Understand how an agent can get the value of a global variable or variables belonging to a certain patch or link or another agent.

Entity detection:
  ~ Understand different ways to detect which agents or patches meet certain conditions (e.g., within a certain distance, have a certain color, have the largest or smallest values of some variable, etc.).

The agents'' interactions, both with their environment and with each other through sensing. Part of the design concepts section of a model''s ODD consists of specifying what the agents can sense: They might be able to sense other agents within a certain distance. They might only be able to detect other agents if they are within a certain angle (e.g., the agent might be able to look forward, but might not be able to see behind itself unless it turns around). Agents might be able to detect certain qualities of one another (e.g., I can see how tall you are, but I can''t see how much money you have).

Agents can interact both spatially and through networks of links. You can create many kinds of links so that agents can belong to many networks (e.g., family, co-workers, members of a church congregation, etc.).

Sensing involves two steps:

1. Detect which entities your agent (or patch) will sense.
1. Get the values of the sensed variables from those entities.

Be sure to code the Business Investor model as you read section 10.4. You will use it in Chapter 11 and it will form the basis for one of the team projects you will present. 
The other team project will use the Telemarketer model from section 13.3. This would be a good time for you and your teammates to get started on your team projects.
',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              1201,
                              'ADAPTATION',
                              'RAILSBACK_GRIMM',
                              'Ch. 11',
                              NULL,
                              NULL,
                              'Agents'' behavior often consists of trying to achieve some **objective**.

I have discussed the way that Adam Smith''s "invisible hand of the market" is a kind of agent-based view of a nation''s economy: Each person (agent) has an objective of trying to maximize his or her own wealth (that''s the agent''s **micromotive**), and in doing so, the population of agents manages unintentionally to maximize the total wealth of the nation (an emergent **macrobehavior** that results from the collective interactions of the agents and their micromotives). 

For Darwin, agents whose objectives are to survive and reproduce under changing environmental conditions achieve emergent phenomena of evolution and speciation.

If we are going to program an agent-based model to simulate such an economy (we saw this in the Sugarscape models), you need to program your agents to try to achieve their objective (maximize their wealth). There are two approaches to this:

1. You could program a sophisticated strategy into your agents.
1. You could program a simple strategy into your agents, but give them the ability to learn from their experience and adapt their behavior according to what they learn. (see section 11.3 for details and an example)

This chapter discusses different kinds of objectives you might have your agents employ. An important concept from decision theory and behavioral economics that might be new to you is **satisficing**. This term, introduced by Herbert Simon[^1] in 1956, refers to making decisions by choosing a "good-enough" option when it would take too much time and effort to determine which option is the absolute best. See section 11.4 for details and an example.

[^1]: Herbert Simon (1916--2001) was a fascinating intellectual. Kind of a renaissance scholar, he made major contributions to political science, economics, cognitive psychology, and artificial intelligence. He won the Nobel Prize for economics in 1978. His publications have been cited more than 250,000 times and even fifteen years after his death, they are still cited more than 10,000 times per year.',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              1301,
                              'PREDICTION',
                              'RAILSBACK_GRIMM',
                              'Ch. 12',
                              NULL,
                              NULL,
                              'In class, we will discuss the telemarketer model.

For the teams working on the telemarketer model, the steps are:

1. Build the model as described in the ODD.
1. Do the analyses in section 13.3.2
1. Next work on two extensions:
      1. Mergers (section 13.5)
      1. Customers remember (section 13.6)

Before class on Thursday, everyone should read Chapter 13 and the ODD for the telemarketer model and be ready to discuss the model in class.
This will be a chance for the teams working on the model to ask questions.
',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              1401,
                              'INTERACTION',
                              'RAILSBACK_GRIMM',
                              'Ch. 13',
                              NULL,
                              NULL,
                              NULL,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              1701,
                              'SCHEDULING',
                              'RAILSBACK_GRIMM',
                              'Ch. 14',
                              NULL,
                              NULL,
                              'A good example of asynchronous updating is the 
[model of breeding synchrony](/files/models/chapter_23/Ch_23_4_breeding_synchrony.nlogo), 
described in [Jovani and Grimm (2008)](/files/models/chapter_05/Jovani_Grimm_2008_Breeding.pdf) 
and in Chapter 23, which I have posted on the class web site: 
<<%CLASS_URL%>files/models/chapter_23/Ch_23_4_breeding_synchrony.nlogo>
',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              1801,
                              'STOCHASTICITY',
                              'RAILSBACK_GRIMM',
                              'Ch. 15',
                              NULL,
                              NULL,
                              NULL,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              1901,
                              'COLLECTIVES',
                              'RAILSBACK_GRIMM',
                              'Ch. 16',
                              NULL,
                              NULL,
                              NULL,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              2001,
                              'PATTERNS',
                              'RAILSBACK_GRIMM',
                              'Ch. 17--18',
                              NULL,
                              NULL,
                              'You can download [the ODD for the BEFORE beech forest model](/files/models/chapter_18/ch18_before_ODD.pdf), which is described in section 18.3, from the class web site: <<%CLASS_URL%>files/models/chapter_18/ch18_before_ODD.pdf>.

I have also posted [a list of published models](/files/models/chapter_18/ch18_ex1_models_list.pdf) in which observed patterns are important: <<%CLASS_URL%>files/models/chapter_18/ch18_ex1_models_list.pdf>',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              2101,
                              'THEORY_DEVELOPMENT',
                              'RAILSBACK_GRIMM',
                              'Ch. 19',
                              NULL,
                              NULL,
                              '<%LATEX_SLOPPY%>
There is an implementation of the [wood hoopoe model](/files/models/chapter_19/ch19_ex2_wood_hoopoes.nlogo), suitable for Exercise 2, on the class web site: <<%CLASS_URL%>files/models/chapter_19/ch19_ex2_wood_hoopoes.nlogo>
<%LATEX_FUSSY%>',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              2201,
                              'PARAMETERIZATION_1',
                              'RAILSBACK_GRIMM',
                              'Ch. 20',
                              NULL,
                              NULL,
                              NULL,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              2301,
                              'PARAMETERIZATION_2',
                              'RAILSBACK_GRIMM',
                              'Ch. 20',
                              NULL,
                              NULL,
                              NULL,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              2401,
                              'ANALYZING_ABMS',
                              'RAILSBACK_GRIMM',
                              'Ch. 22',
                              NULL,
                              NULL,
                              NULL,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              2501,
                              'SENSITIVITY_ROBUSTNESS',
                              'RAILSBACK_GRIMM',
                              'Ch. 23',
                              NULL,
                              NULL,
                              'You can download the [model of breeding synchrony](/files/models/chapter_23/Ch_23_4_breeding_synchrony.nlogo), described in [Jovani and Grimm (2008)](/files/models/chapter_05/Jovani_Grimm_2008_Breeding.pdf) and in section 23.4, from the class web site: <<%CLASS_URL%>files/models/chapter_23/Ch_23_4_breeding_synchrony.nlogo>',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              2601,
                              'LOOKING_AHEAD',
                              'RAILSBACK_GRIMM',
                              'Ch. 24',
                              NULL,
                              NULL,
                              NULL,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              202,
                              'MODELING_CYCLE',
                              'ARTIFICIAL_SOCIETIES',
                              NULL,
                              NULL,
                              'You can download "[Artificial Societies](/files/reading/Tyson_1997_Artificial_Societies.pdf)" from Brightspace or <<%CLASS_URL%>files/reading/Tyson_1997_Artificial_Societies.pdf>.',
                              'The article "Artificial Life" gives you a feel for how an early agent-based model called "Sugarscape" was used as part of a very influential research project in the 1990s. Joshua Epstein and Robert Axtell who wrote Sugarscape are highly respected pioneers in agent-based modeling and the Sugarscape model set off a revolution in agent-based modeling by showing that a very simple model could reproduce complex phenomena that are observed in real societies. As you read through this article, think about what the different applications of agent-based models have in common. Do these suggest questions that you might be interested in exploring with agent-based models. Do you have questions, as you read this, about whether computer modeling can really tell you about real societies?

',
                              0,
                              0,
                              0,
                              0,
                              0,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              250,
                              'MODELING_CYCLE',
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              'Agent-based models are often used to examine **emergent** phenomena. Neither reading describes clearly what _emergence_ means. There is no simple definition, but during the semester we will pay a lot of attention to learning about emergence and trying to understand it. Do not worry if you don''t understand emergence at this point. Emergence is difficult to put into words, and it''s much easier to understand from experience. Over the course of the semester, we will work together to understand what emergence is and how to study it.
',
                              0,
                              0,
                              0,
                              0,
                              1,
                              0
                          );

INSERT INTO reading_items (
                              rd_item_id,
                              rd_group,
                              source_id,
                              chapter,
                              pages,
                              item_extra,
                              reading_notes,
                              undergraduate_only,
                              graduate_only,
                              optional,
                              rd_prologue,
                              rd_epilogue,
                              rd_break_before
                          )
                          VALUES (
                              200,
                              'MODELING_CYCLE',
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              0,
                              0,
                              0,
                              1,
                              0,
                              0
                          );


-- Table: reading_sources
CREATE TABLE reading_sources (
    source_id            TEXT,
    title                TEXT,
    short_title          TEXT,
    markdown_title       TEXT,
    short_markdown_title TEXT,
    latex_title          TEXT,
    short_latex_title    TEXT,
    citation             TEXT,
    textbook             BOOLEAN,
    handout              BOOLEAN,
    url                  TEXT
);

INSERT INTO reading_sources (
                                source_id,
                                title,
                                short_title,
                                markdown_title,
                                short_markdown_title,
                                latex_title,
                                short_latex_title,
                                citation,
                                textbook,
                                handout,
                                url
                            )
                            VALUES (
                                'RAILSBACK_GRIMM',
                                'Agent-Based and Individual-Based Modeling',
                                'Agent-Based Modeling',
                                '<%RAILSBACK%>',
                                '<%ALT_SHORT_RAILSBACK%>',
                                'Agent-Based \& Individual-Based Modeling',
                                'Railsback \& Grimm',
                                'Steven F. Railsback and Volker Grimm, _Agent-Based and Individual-Based Modeling: A Practical Introduction_ (Princeton University Press, 2012). ISBN: 978-0-691-13674-5',
                                1,
                                0,
                                NULL
                            );

INSERT INTO reading_sources (
                                source_id,
                                title,
                                short_title,
                                markdown_title,
                                short_markdown_title,
                                latex_title,
                                short_latex_title,
                                citation,
                                textbook,
                                handout,
                                url
                            )
                            VALUES (
                                'ARTIFICIAL_SOCIETIES',
                                'Artificial Societies',
                                'Artificial Societies',
                                '"Artificial Societies"',
                                '"Artificial Societies"',
                                '``Artificial Societies''''',
                                '``Artificial Societies''''',
                                'P. Tyson, "Artificial Societies," Technology Review **100** (3), 15--17 (1997).',
                                0,
                                1,
                                '/files/reading/Tyson_Artificial_Societies_1997.pdf'
                            );

INSERT INTO reading_sources (
                                source_id,
                                title,
                                short_title,
                                markdown_title,
                                short_markdown_title,
                                latex_title,
                                short_latex_title,
                                citation,
                                textbook,
                                handout,
                                url
                            )
                            VALUES (
                                'AXTELL_ECON',
                                'Economics as Distributed Computation',
                                'Economics as Distributed Computation',
                                '"Economics as Distributed Computation"',
                                '"Economics as Distributed Computation"',
                                '``Economics as Distributed Computation''''',
                                '``Economics as Distributed Computation''''',
                                'Robert L. Axtell, “Economics as Distributed Computation,” in  Takao Terano, Hiroshi Deguchi, and Keiki Takadama (eds) _Meeting the Challenge of Social Problems via Agent-Based Simulation_(Springer,2003), pp. 3--23.
',
                                0,
                                1,
                                NULL
                            );


-- Table: text_codes
CREATE TABLE text_codes (
    code_name   TEXT,
    code_value  TEXT,
    latex_value TEXT,
    print_value INTEGER
);

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'MED_ABM_BOOK',
                           'Agent-Based Modeling',
                           'Agent-Based Modeling',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'SHORTEST_ABM_BOOK',
                           'AB&IBM',
                           'AB\&IBM',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'ALT_SHORT_ABM_BOOK',
                           'Railsback & Grimm',
                           'Railsback \& Grimm',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'SHORT_ABM_BOOK',
                           'Agent-Based Modeling',
                           'Agent-Based Modeling',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'ABM_BOOK',
                           'Agent-Based and Individual-Based Modeling',
                           'Agent-Based and Individual-Based Modeling',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'SHORTEST_RAILSBACK',
                           'AB&IBM',
                           'AB\&IBM',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'ALT_SHORT_RAILSBACK',
                           'Railsback & Grimm',
                           'Railsback \& Grimm',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'SHORT_RAILSBACK',
                           'Agent-Based Modeling',
                           'Agent-Based Modeling',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'MED_RAILSBACK',
                           'Agent-Based Modeling',
                           'Agent-Based Modeling',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'RAILSBACK',
                           'Agent-Based and Individual-Based Modeling',
                           'Agent-Based and Individual-Based Modeling',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'NETLOGO',
                           'NetLogo',
                           '\NetLogo{}',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'CLASS_URL',
                           'https://ees4760.jgilligan.org/',
                           'https://ees4760.jgilligan.org/',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'LATEX_FUSSY',
                           '',
                           '\fussy',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'LATEX_SLOPPY',
                           '',
                           '\sloppy',
                           NULL
                       );

INSERT INTO text_codes (
                           code_name,
                           code_value,
                           latex_value,
                           print_value
                       )
                       VALUES (
                           'LATEX_BREAK',
                           '',
                           '\break',
                           NULL
                       );


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
