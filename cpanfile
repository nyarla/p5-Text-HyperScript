requires 'perl', '5.008001';
requires 'Exporter::Lite', '>= 0.09';
requires 'HTML::Escape', '>= 1.11';

on 'test' => sub {
    requires 'Test2::V0', '0';
};
