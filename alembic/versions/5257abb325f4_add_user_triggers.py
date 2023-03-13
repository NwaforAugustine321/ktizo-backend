"""“add_user_triggers”

Revision ID: 5257abb325f4
Revises: d431f5ff3eec
Create Date: 2023-02-12 13:48:26.007838

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '5257abb325f4'
down_revision = 'd431f5ff3eec'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('user', sa.Column('is_spotify_connected', sa.Boolean(), nullable=True))
    op.add_column('user', sa.Column('is_stripe_connected', sa.Boolean(), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('user', 'is_stripe_connected')
    op.drop_column('user', 'is_spotify_connected')
    # ### end Alembic commands ###
