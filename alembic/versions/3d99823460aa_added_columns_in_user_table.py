"""added columns in user table

Revision ID: 3d99823460aa
Revises: 4466dd27b44e
Create Date: 2022-05-03 17:01:49.607686

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '3d99823460aa'
down_revision = '4466dd27b44e'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('user', sa.Column('music_rating', sa.String(length=255), nullable=True))
    op.add_column('user', sa.Column('song_writer', postgresql.JSONB(astext_type=sa.Text()), nullable=True))
    op.add_column('user', sa.Column('own_masters', postgresql.JSONB(astext_type=sa.Text()), nullable=True))
    op.add_column('user', sa.Column('music_publishing', sa.String(length=255), nullable=True))
    op.add_column('user', sa.Column('music_publishing_owners', postgresql.JSONB(astext_type=sa.Text()), nullable=True))
    op.add_column('user', sa.Column('master_recording', sa.String(length=255), nullable=True))
    op.add_column('user', sa.Column('master_recording_owners', postgresql.JSONB(astext_type=sa.Text()), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('user', 'master_recording_owners')
    op.drop_column('user', 'master_recording')
    op.drop_column('user', 'music_publishing_owners')
    op.drop_column('user', 'music_publishing')
    op.drop_column('user', 'own_masters')
    op.drop_column('user', 'song_writer')
    op.drop_column('user', 'music_rating')
    # ### end Alembic commands ###