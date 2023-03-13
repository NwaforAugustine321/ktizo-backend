"""licence table

Revision ID: 4972bd4305e6
Revises: 7681bc92f644
Create Date: 2022-05-20 15:21:00.650135

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql
import sqlalchemy_utils

# revision identifiers, used by Alembic.
revision = '4972bd4305e6'
down_revision = '7681bc92f644'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('licence',
    sa.Column('id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('user_id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('song_id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('date', sa.Date(), nullable=True),
    sa.Column('email', sa.String(length=255), nullable=True),
    sa.Column('to', sa.String(length=255), nullable=True),
    sa.Column('master_recording', sa.String(length=255), nullable=True),
    sa.Column('written_by', postgresql.JSONB(astext_type=sa.Text()), nullable=True),
    sa.Column('published_by', postgresql.JSONB(astext_type=sa.Text()), nullable=True),
    sa.Column('performed_by', sa.String(length=255), nullable=True),
    sa.Column('label', sa.String(length=255), nullable=True),
    sa.Column('tv_show', sa.String(length=255), nullable=True),
    sa.Column('show_description', sa.String(length=2000), nullable=True),
    sa.Column('use', sa.String(length=2000), nullable=True),
    sa.Column('onetime_fee', sa.String(length=255), nullable=True),
    sa.Column('direct_performancefee', sa.String(length=255), nullable=True),
    sa.Column('master_licencefee', sa.String(length=255), nullable=True),
    sa.Column('sync_licencefee', sa.String(length=255), nullable=True),
    sa.Column('performance_fee', sa.String(length=255), nullable=True),
    sa.Column('reached_at', sa.String(length=1000), nullable=True),
    sa.Column('reachedat_email', sa.String(length=255), nullable=True),
    sa.Column('status', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['song_id'], ['Songs.id'], ondelete='cascade'),
    sa.ForeignKeyConstraint(['user_id'], ['user.id'], ondelete='cascade'),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('licence')
    # ### end Alembic commands ###