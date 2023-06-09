"""Added columns in similar_track table

Revision ID: 2737e100c02c
Revises: 2754002eec0f
Create Date: 2022-05-29 17:44:52.554255

"""
from alembic import op
import sqlalchemy as sa
import sqlalchemy_utils


# revision identifiers, used by Alembic.
revision = '2737e100c02c'
down_revision = '2754002eec0f'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('similar_track', sa.Column('song_id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False))
    op.add_column('similar_track', sa.Column('artist_id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=True))
    op.create_foreign_key(None, 'similar_track', 'Songs', ['song_id'], ['id'], ondelete='cascade')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint(None, 'similar_track', type_='foreignkey')
    op.drop_column('similar_track', 'artist_id')
    op.drop_column('similar_track', 'song_id')
    # ### end Alembic commands ###
