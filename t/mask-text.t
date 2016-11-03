use Test::Most;
use OpusVL::Text::Util qw/mask_text/;

is mask_text('*', '(\d{4}).*(\d{3})', '456456564654654'), '4564********654', 'Mask card';
is mask_text('*', '.(\d{4}).*(\d{3}).', '456456564654654'), '*5645******465*', 'Mask card';

is mask_text('*', '(\d{4}).*(\d{3})', 'rabbits'), '*******', 'fail secure';

done_testing;
